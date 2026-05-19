local addonName, ns = ...

OneWoW_CatalogData_Quests_DB = OneWoW_CatalogData_Quests_DB or {
    quests = {},
    completion = {},
    favorites = {
        quests = {},
        npcs = {},
    }
}

function ns:GetDB()
    return OneWoW_CatalogData_Quests_DB
end

function ns.GetQuestMapID(questID)
    if not questID then return nil end

    -- 1. Quest UI Map (validate)
    if C_QuestLog and C_QuestLog.GetQuestUiMapID then
        local id = C_QuestLog.GetQuestUiMapID(questID)
        if id and id ~= 0 then
            return id
        end
    end

    -- 2. Quest Log Info (validate)
    if C_QuestLog and C_QuestLog.GetLogIndexForQuestID then
        local logIndex = C_QuestLog.GetLogIndexForQuestID(questID)
        if logIndex then
            local info = C_QuestLog.GetInfo(logIndex)
            if info and info.mapID and info.mapID ~= 0 then
                return info.mapID
            end
        end
    end

    return nil
end