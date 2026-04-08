local addonName, ns = ...

function ns.OpenMapToQuest(quest)
    if not quest or not quest.mapID then return end

    local mapID = quest.mapID

    -- Ensure map is open
    if not WorldMapFrame or not WorldMapFrame:IsShown() then
        ToggleWorldMap()
    end

    -- Force correct map
    if WorldMapFrame then
        WorldMapFrame:SetMapID(mapID)
    end

    local usedBlizzardTracking = false

    -- 🧠 Try Blizzard native tracking FIRST
    if quest.id and C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(quest.id) then
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedQuestID then
            C_SuperTrack.SetSuperTrackedQuestID(quest.id)
            usedBlizzardTracking = true
        end
    end

    -- 🔥 Fallback: ALWAYS place a waypoint if Blizzard didn't handle it
    local x, y = nil, nil

    if quest.coords and quest.coords.x and quest.coords.y then
        x = quest.coords.x
        y = quest.coords.y
    end

    -- 🧠 If Blizzard tracking worked, we ADD waypoint (not replace)
    if usedBlizzardTracking then
        if x and y then
            local point = UiMapPoint.CreateFromCoordinates(mapID, x, y)
            if point then
                C_Map.SetUserWaypoint(point)
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
            end
        end

    -- 🔥 If Blizzard failed, we fallback completely
    else
        x = x or 0.5
        y = y or 0.5

        local point = UiMapPoint.CreateFromCoordinates(mapID, x, y)

        if point then
            C_Map.SetUserWaypoint(point)
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
    end
end