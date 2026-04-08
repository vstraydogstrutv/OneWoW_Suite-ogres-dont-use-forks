local addonName, ns = ...

ns.QuestNPCLink = {}

function ns.QuestNPCLink:Link(questID, quest)
    if not quest or not quest.start then return end

    local npcID = quest.start.npcID
    if not npcID then return end

    local db = ns:GetDB()
    db.npcs = db.npcs or {}

    db.npcs[npcID] = db.npcs[npcID] or {
        name = quest.start.name,
        quests = {}
    }

    db.npcs[npcID].quests[questID] = true
end