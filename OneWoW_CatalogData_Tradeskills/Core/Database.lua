local _, ns = ...

ns.DatabaseDefaults = {
    settings = {
        enabled = true,
        autoScan = true,
    },
    version = 1,
    itemCache = {},
    scanCache = {},
}

function ns:MigrateScanCacheKeys()
    local db = OneWoW_CatalogData_Tradeskills_DB
    if not db or not db.scanCache then return end

    local newCache = {}
    for oldKey, data in pairs(db.scanCache) do
        local realm, name = oldKey:match("^(.+)-(.+)$")
        if realm and name then
            local newKey = name .. "-" .. realm
            newCache[newKey] = data
        else
            newCache[oldKey] = data
        end
    end
    db.scanCache = newCache
end

function ns:GetSettings()
    return OneWoW_CatalogData_Tradeskills_DB and OneWoW_CatalogData_Tradeskills_DB.settings or {}
end

function ns:GetDB()
    return OneWoW_CatalogData_Tradeskills_DB
end
