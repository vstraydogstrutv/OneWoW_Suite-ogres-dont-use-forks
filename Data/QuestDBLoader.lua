local _, ns = ...

ns.ExternalQuestDB = ns.ExternalQuestDB or {}

local db = ns.ExternalQuestDB

local function MergeDB(source)
    if not source then return end

    for questID, questData in pairs(source) do
        db[questID] = questData
    end
end

-- Merge expansion DBs
if OneWoW_QuestDB_Classic then
    MergeDB(OneWoW_QuestDB_Classic)
end

if OneWoW_QuestDB_BC then
    MergeDB(OneWoW_QuestDB_BC)
end

if OneWoW_QuestDB_Wrath then
    MergeDB(OneWoW_QuestDB_Wrath)
end

if OneWoW_QuestDB_Cata then
    MergeDB(OneWoW_QuestDB_Cata)
end

if OneWoW_QuestDB_MoP then
    MergeDB(OneWoW_QuestDB_MoP)
end

if OneWoW_QuestDB_WoD then
    MergeDB(OneWoW_QuestDB_WoD)
end

if OneWoW_QuestDB_Legion then
    MergeDB(OneWoW_QuestDB_Legion)
end

if OneWoW_QuestDB_BFA then
    MergeDB(OneWoW_QuestDB_BFA)
end

if OneWoW_QuestDB_SL then
    MergeDB(OneWoW_QuestDB_SL)
end

if OneWoW_QuestDB_DF then
    MergeDB(OneWoW_QuestDB_DF)
end

if OneWoW_QuestDB_TWW then
    MergeDB(OneWoW_QuestDB_TWW)
end

if OneWoW_QuestDB_Midnight then
    MergeDB(OneWoW_QuestDB_Midnight)
end

print("Loaded External QuestDB:", #db)