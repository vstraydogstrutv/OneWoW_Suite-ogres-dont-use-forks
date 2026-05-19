local _, ns = ...

ns.QuestMapResolver = {}

local Resolver = ns.QuestMapResolver

function Resolver:GetBestMapID(questID, questData)
    if not questData then return nil end

    local candidates = questData.mapCandidates
    if not candidates then return nil end

    -- 1. NPC maps (HIGHEST PRIORITY)
    if candidates.npc and #candidates.npc > 0 then
        for _, mapID in ipairs(candidates.npc) do
            if mapID and mapID ~= 0 then
                return mapID, "npc"
            end
        end
    end

    -- 2. Zone → Map via DB2
    if candidates.zone and ns.AreaToMap then
        for _, areaID in ipairs(candidates.zone) do
            local maps = ns.AreaToMap[areaID]
            if maps and #maps > 0 then
                for _, mapID in ipairs(maps) do
                    if mapID and mapID ~= 0 then
                        return mapID, "zone"
                    end
                end
            end
        end
    end

    return nil
end