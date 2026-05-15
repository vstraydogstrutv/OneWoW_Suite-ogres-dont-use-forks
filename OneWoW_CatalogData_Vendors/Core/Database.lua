-- OneWoW_CatalogData_Vendors/Core/Database.lua
local _, ns = ...

ns.DatabaseDefaults = {
    settings = {
        enabled = true,
        autoScan = true,
    },
    version = 2,
    vendors = {},
    nameCache = {},
    itemCache = {},
}

function ns:GetSettings()
    return OneWoW_CatalogData_Vendors_DB and OneWoW_CatalogData_Vendors_DB.settings or {}
end

function ns:GetDB()
    return OneWoW_CatalogData_Vendors_DB
end
