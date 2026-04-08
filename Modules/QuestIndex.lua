local addonName, ns = ...

ns.QuestIndex = {
    byMap = {},
    byExpansion = {},
    byCategory = {},
    byNPC = {},
    byName = {},
}

local QuestIndex = ns.QuestIndex

function QuestIndex:IndexQuest(questID, quest)
    if not quest then return end

    -- Map
    if quest.mapID then
        self.byMap[quest.mapID] = self.byMap[quest.mapID] or {}
        self.byMap[quest.mapID][questID] = true
    end

    -- Expansion
    if quest.expansion then
        self.byExpansion[quest.expansion] = self.byExpansion[quest.expansion] or {}
        self.byExpansion[quest.expansion][questID] = true
    end

    -- Category
    if quest.category then
        self.byCategory[quest.category] = self.byCategory[quest.category] or {}
        self.byCategory[quest.category][questID] = true
    end

    -- NPC
    if quest.start and quest.start.id then
        local npcID = quest.start.id
        self.byNPC[npcID] = self.byNPC[npcID] or {}
        self.byNPC[npcID][questID] = true
    end

    -- Name tokens
    if quest.name then
        for word in string.gmatch(string.lower(quest.name), "%w+") do
            self.byName[word] = self.byName[word] or {}
            self.byName[word][questID] = true
        end
    end
end

function QuestIndex:Search(text)
    if not text or text == "" then return {} end

    local results = {}
    local words = {}

    for word in string.gmatch(string.lower(text), "%w+") do
        table.insert(words, word)
    end

    for i, word in ipairs(words) do
        local set = self.byName[word]
        if not set then return {} end

        if i == 1 then
            for id in pairs(set) do
                results[id] = true
            end
        else
            for id in pairs(results) do
                if not set[id] then
                    results[id] = nil
                end
            end
        end
    end

    return results
end