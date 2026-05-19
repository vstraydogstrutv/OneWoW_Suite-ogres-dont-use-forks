local _, ns = ...

ns.MapResolver = {}

local MapResolver = ns.MapResolver

-- Manual overrides (authoritative when API fails)
local MAP_TO_EXPANSION = {
    [37]   = 0,  -- Elwynn Forest (Classic)
    [84]   = 0,  -- Stormwind City (Classic)
    [2352] = 11, -- Founder's Point (Midnight Housing)
}

-- Blocked maps (bad signals unless overridden)
local BLOCKED_MAPS = {
    [84] = true, -- Stormwind
    [85] = true, -- Orgrimmar
}

-- Unknown tracking (session only for now)
local unknownMaps = {}

-- Public: Resolve mapID → expansionID
function MapResolver:GetExpansionForMap(mapID)
    
    print("MapResolver HIT:", mapID)
    print("UiMapParent exists?", ns.UiMapParent ~= nil)

    if not mapID or mapID == 0 then
        return nil, "unknown"
    end

    -- 1. Manual override (absolute authority)
    if MAP_TO_EXPANSION[mapID] then
        return MAP_TO_EXPANSION[mapID], "high"
    end

        -- 2. Blocked maps (bad signals)
    if BLOCKED_MAPS[mapID] then
        return nil, "blocked"
    end

    -- 3. Parent chain resolution (high confidence)
    local visited = {}
    local current = mapID

    while current and not visited[current] do
            print("Traversing:", current)

        visited[current] = true

        -- Manual override still applies at any level
        if MAP_TO_EXPANSION[current] then
            return MAP_TO_EXPANSION[current], "high"
        end

        -- Walk up parent chain
        if ns.UiMapParent and ns.UiMapParent[current] then
            current = ns.UiMapParent[current]
        else
            break
        end
    end

    -- 4. Link fallback (medium confidence)
    if ns.UiMapLinks and ns.UiMapLinks[mapID] then
        for _, linkedMap in ipairs(ns.UiMapLinks[mapID]) do
            local exp = nil

            local visitedLink = {}
            local currentLink = linkedMap

            while currentLink and not visitedLink[currentLink] do
                visitedLink[currentLink] = true

                if MAP_TO_EXPANSION[currentLink] then
                    exp = MAP_TO_EXPANSION[currentLink]
                    break
                end

                if ns.UiMapParent and ns.UiMapParent[currentLink] then
                    currentLink = ns.UiMapParent[currentLink]
                else
                    break
                end
            end

            if exp then
                return exp, "medium"
            end
        end
    end

    -- 5. Track unknown maps for later analysis
    if not unknownMaps[mapID] then
        unknownMaps[mapID] = true
        print("MapResolver: Unknown mapID:", mapID)
    end

    print("Chain step:", mapID, "→", current)
    
    return nil, "unknown"
end

-- Debug: Get unknown maps (for later tooling)
function MapResolver:GetUnknownMaps()
    return unknownMaps
end