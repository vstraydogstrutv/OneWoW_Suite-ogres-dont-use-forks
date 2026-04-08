-- OneWoW Addon File
-- OneWoW_CatalogData_Quests/OneWoW_CatalogData_Quests.lua
-- Created by MichinMuggin (Ricky)
local addonName, ns = ...

_G.OneWoW_CatalogData_Quests = ns

OneWoW_CatalogData_Quests_API = {

    GetQuest = function(questID)
        return ns.QuestData and ns.QuestData:GetQuest(questID)
    end,

    GetQuestCount = function()
        return ns.QuestData and ns.QuestData:GetQuestCount() or 0
    end,

    GetCompletedCharacters = function(questID)
        return ns.CompletionTracker and ns.CompletionTracker:GetCompletedCharacters(questID) or {}
    end,

    -- 🔥 NEW

    SearchQuests = function(text)
        return ns.QuestIndex and ns.QuestIndex:Search(text)
    end,

    GetQuestsByNPC = function(npcID)
        return ns.QuestIndex and ns.QuestIndex.byNPC[npcID]
    end,

    ToggleFavorite = function(questID)
        if ns.QuestFavorites then
            ns.QuestFavorites:Toggle(questID)
        end
    end,

    IsFavorited = function(questID)
        return ns.QuestFavorites and ns.QuestFavorites:IsFavorited(questID)
    end,

    OpenMapToQuest = function(quest)
        if ns.OpenMapToQuest then
            ns.OpenMapToQuest(quest)
        end
    end,
}
