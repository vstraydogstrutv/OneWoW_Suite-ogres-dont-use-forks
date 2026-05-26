local _, ns = ...

-- ============================================================================
-- VendorCategories
-- ============================================================================
-- User-assignable vendor types ("Quartermaster", "Mount Vendor", etc.) used
-- by the Vendors tab for display and filtering.
--
-- The category KEY is the stable identifier stored on
-- OneWoW_CatalogData_Vendors_DB.global.vendors[npcID].category.
-- The label is resolved through ns.L at runtime so it stays localized.
-- ============================================================================

ns.VendorCategories = ns.VendorCategories or {}
local VC = ns.VendorCategories

VC.ORDER = {
    "general",
    "reagent",
    "repair",
    "quartermaster",
    "class_trainer",
    "profession_trainer",
    "profession_supplies",
    "mount",
    "pet",
    "toy",
    "transmog",
    "heirloom",
    "pvp",
    "currency",
    "food",
    "other",
}

local LOCALE_KEYS = {
    general              = "VENDORS_CATEGORY_GENERAL",
    reagent              = "VENDORS_CATEGORY_REAGENT",
    repair               = "VENDORS_CATEGORY_REPAIR",
    quartermaster        = "VENDORS_CATEGORY_QUARTERMASTER",
    class_trainer        = "VENDORS_CATEGORY_CLASS_TRAINER",
    profession_trainer   = "VENDORS_CATEGORY_PROFESSION_TRAINER",
    profession_supplies  = "VENDORS_CATEGORY_PROFESSION_SUPPLIES",
    mount                = "VENDORS_CATEGORY_MOUNT",
    pet                  = "VENDORS_CATEGORY_PET",
    toy                  = "VENDORS_CATEGORY_TOY",
    transmog             = "VENDORS_CATEGORY_TRANSMOG",
    heirloom             = "VENDORS_CATEGORY_HEIRLOOM",
    pvp                  = "VENDORS_CATEGORY_PVP",
    currency             = "VENDORS_CATEGORY_CURRENCY",
    food                 = "VENDORS_CATEGORY_FOOD",
    other                = "VENDORS_CATEGORY_OTHER",
}

function VC:GetLabel(key)
    if not key or key == "" then
        return ns.L["VENDORS_CATEGORY_NONE"]
    end
    local localeKey = LOCALE_KEYS[key]
    if localeKey and ns.L and ns.L[localeKey] then
        return ns.L[localeKey]
    end
    return key
end

function VC:IsValid(key)
    if not key then return false end
    return LOCALE_KEYS[key] ~= nil
end
