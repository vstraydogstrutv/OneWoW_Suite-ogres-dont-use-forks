local _, ns = ...

ns.DatabaseDefaults = {
    settings = {
        enabled = true,
    },
    version = 1,
    itemCache = {},
}

function ns:GetSettings()
    return OneWoW_CatalogData_Journal_DB and OneWoW_CatalogData_Journal_DB.settings or {}
end

function ns:GetDB()
    return OneWoW_CatalogData_Journal_DB
end
