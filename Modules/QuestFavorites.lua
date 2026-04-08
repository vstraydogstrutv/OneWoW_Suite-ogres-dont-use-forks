local addonName, ns = ...

ns.QuestFavorites = {}

function ns.QuestFavorites:Toggle(questID)
    local db = ns:GetDB()
    local quest = ns.QuestData:GetQuest(questID)
    if not quest then return end

    db.favorites.quests[questID] = not db.favorites.quests[questID]

    if quest.start and quest.start.id then
        if db.favorites.quests[questID] then
            db.favorites.npcs[quest.start.id] = true
        else
            db.favorites.npcs[quest.start.id] = nil
        end
    end
end

function ns.QuestFavorites:IsFavorited(questID)
    return ns:GetDB().favorites.quests[questID] == true
end