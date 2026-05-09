local _, OneWoW_Bags = ...

local function CompareValues(aValue, bValue, descending)
    if aValue == bValue then return 0 end
    if descending then
        return aValue > bValue and -1 or 1
    end
    return aValue < bValue and -1 or 1
end

local function CompactButtons(buttons)
    local count = #buttons
    local writeIndex = 1
    for readIndex = 1, count do
        local button = buttons[readIndex]
        if button then
            buttons[writeIndex] = button
            writeIndex = writeIndex + 1
        end
    end
    for index = writeIndex, count do
        buttons[index] = nil
    end
end

local function CompareHasItem(a, b)
    local aHasItem = a and a.owb_hasItem and 1 or 0
    local bHasItem = b and b.owb_hasItem and 1 or 0
    return CompareValues(aHasItem, bHasItem, true)
end

local function CompareDefault(a, b)
    local result = CompareValues(a and a.owb_bagID or 0, b and b.owb_bagID or 0)
    if result ~= 0 then return result end
    return CompareValues(a and a.owb_slotID or 0, b and b.owb_slotID or 0)
end

local function GetItemID(button)
    return button and button.owb_itemInfo and button.owb_itemInfo.itemID
end

local function CompareName(a, b)
    local aID = GetItemID(a)
    local bID = GetItemID(b)
    local result = CompareValues(aID and 1 or 0, bID and 1 or 0, true)
    if result ~= 0 then return result end
    if not aID or not bID then return 0 end
    local aName = C_Item.GetItemNameByID(aID) or ""
    local bName = C_Item.GetItemNameByID(bID) or ""
    return CompareValues(aName, bName)
end

local function CompareRarity(a, b)
    local aQ = a and a.owb_itemInfo and a.owb_itemInfo.quality or 0
    local bQ = b and b.owb_itemInfo and b.owb_itemInfo.quality or 0
    return CompareValues(aQ, bQ, true)
end

local function CompareItemLevel(a, b)
    local aLink = a and a.owb_itemInfo and a.owb_itemInfo.hyperlink
    local bLink = b and b.owb_itemInfo and b.owb_itemInfo.hyperlink
    local aIlvl = aLink and (select(4, C_Item.GetItemInfo(aLink)) or 0) or 0
    local bIlvl = bLink and (select(4, C_Item.GetItemInfo(bLink)) or 0) or 0
    return CompareValues(aIlvl, bIlvl, true)
end

local function CompareType(a, b)
    local aID = GetItemID(a)
    local bID = GetItemID(b)
    local result = CompareValues(aID and 1 or 0, bID and 1 or 0, true)
    if result ~= 0 then return result end
    if not aID or not bID then return 0 end
    local _, _, _, _, _, aClass, aSub = C_Item.GetItemInfoInstant(aID)
    local _, _, _, _, _, bClass, bSub = C_Item.GetItemInfoInstant(bID)
    aClass = aClass or 0
    bClass = bClass or 0
    result = CompareValues(aClass, bClass)
    if result ~= 0 then return result end
    aSub = aSub or 0
    bSub = bSub or 0
    return CompareValues(aSub, bSub)
end

local function CompareExpansion(a, b)
    local WH = OneWoW_Bags.WindowHelpers
    local aExp = a and a.owb_itemInfo and WH:ResolveExpansionID(a.owb_itemInfo, a.owb_bagID, a.owb_slotID) or -1
    local bExp = b and b.owb_itemInfo and WH:ResolveExpansionID(b.owb_itemInfo, b.owb_bagID, b.owb_slotID) or -1
    return CompareValues(aExp, bExp, true)
end

local COMPARE_BY_MODE = {
    default = CompareDefault,
    name = CompareName,
    rarity = CompareRarity,
    ilvl = CompareItemLevel,
    type = CompareType,
    expansion = CompareExpansion,
}

local LEGACY_TIE_BREAKERS = {
    rarity = { "name" },
    ilvl = { "rarity" },
    type = { "name" },
    expansion = { "rarity" },
}

local function CompareMode(a, b, mode)
    local compare = COMPARE_BY_MODE[mode]
    return compare and compare(a, b) or 0
end

local function CompareChain(a, b, modes)
    local hasItemResult = CompareHasItem(a, b)
    if hasItemResult ~= 0 then return hasItemResult end

    for _, mode in ipairs(modes) do
        local result = CompareMode(a, b, mode)
        if result ~= 0 then return result end
    end
    return 0
end

function OneWoW_Bags:SortButtons(buttons, overrideSortMode, overrideSubSortMode)
    local sortMode = overrideSortMode or "default"
    if sortMode == "none" then
        return buttons
    end

    local subSortMode = overrideSubSortMode
    if subSortMode == "none" or subSortMode == sortMode then
        subSortMode = nil
    end

    local modes = { sortMode }
    if subSortMode then
        modes[2] = subSortMode
        modes[3] = "default"
    else
        local tieBreakers = LEGACY_TIE_BREAKERS[sortMode]
        if tieBreakers then
            for _, mode in ipairs(tieBreakers) do
                modes[#modes + 1] = mode
            end
        end
    end

    if modes[#modes] ~= "default" then
        modes[#modes + 1] = "default"
    end

    CompactButtons(buttons)
    sort(buttons, function(a, b)
        return CompareChain(a, b, modes) < 0
    end)

    return buttons
end
