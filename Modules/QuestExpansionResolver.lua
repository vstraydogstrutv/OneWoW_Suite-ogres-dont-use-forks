local _, ns = ...

ns.QuestExpansionResolver = {}

local Resolver = ns.QuestExpansionResolver

local unknownQuests = {}

-- Authoritative overrides (you control truth here)
local QUEST_EXPANSION_OVERRIDE = {
    [65436] = 9,  -- The Dragon Isles Await (Dragonflight)
}

-- Public: Resolve quest → expansion
function Resolver:GetExpansion(questID, questData)

    if not questID then return nil end

    -- 1. Explicit override (absolute authority)
    if QUEST_EXPANSION_OVERRIDE[questID] then
        return QUEST_EXPANSION_OVERRIDE[questID], "high"
    end

    -- 2. Existing stored value (use as fallback, not authority)
    local existingExpansion = nil
    if questData and questData.expansion ~= nil then
        existingExpansion = questData.expansion
    end

    -- 3. Map-based resolution (with confidence)
    if questData and questData.mapID and ns.MapResolver then
        local expansionID, confidence = ns.MapResolver:GetExpansionForMap(questData.mapID)

        -- Reject bad signals outright
        if confidence == "blocked" then
            return nil
        end

        -- High confidence = safe
        if confidence == "high" then
            return expansionID
        end

        -- Medium confidence = fallback if nothing better
        if confidence == "medium" then
            return expansionID
        end
    
        -- Fallback to previously stored value if nothing resolved
        if existingExpansion ~= nil then
            return existingExpansion, "low"
        end    

    end

    -- 4. Unknown / unresolved
    if questID and not unknownQuests[questID] then
        unknownQuests[questID] = true
        print("Unknown quest expansion:", questID)
    end

    return nil
end

-- Debug helper
function Resolver:GetOverrides()
    return QUEST_EXPANSION_OVERRIDE
end