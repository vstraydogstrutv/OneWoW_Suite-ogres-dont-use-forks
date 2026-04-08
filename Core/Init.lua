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
    if C_QuestLog and C_QuestLog.GetQuestUiMapID then
        local id = C_QuestLog.GetQuestUiMapID(questID)
        if id then return id end
    end

    local logIndex = C_QuestLog.GetLogIndexForQuestID(questID)
    if logIndex then
        local info = C_QuestLog.GetInfo(logIndex)
        if info then return info.mapID end
    end
end