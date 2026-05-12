local _, OneWoW_Bags = ...

local OneWoW_GUI = LibStub("OneWoW_GUI-1.0", true)
if not OneWoW_GUI then return end

local BankTypes = OneWoW_Bags.BankTypes
local ItemPool = OneWoW_Bags.ItemPool

local ipairs, pairs, tinsert, wipe = ipairs, pairs, tinsert, wipe
local C_Bank, C_Container = C_Bank, C_Container

OneWoW_Bags.BankSet = {}
local BankSet = OneWoW_Bags.BankSet

BankSet.slots = {}
BankSet.totalSlots = 0
BankSet.freeSlots = 0
BankSet.isBuilt = false
BankSet.bagContainerFrames = {}
BankSet.buttonList = {}
BankSet.bagRanges = {}
BankSet._allButtonsScratch = {}
BankSet._bagButtonsScratch = {}

local function CopyRange(source, startIndex, stopIndex, dest)
    wipe(dest)
    if not startIndex or not stopIndex then
        return dest
    end
    for index = startIndex, stopIndex do
        tinsert(dest, source[index])
    end
    return dest
end

local function GetOrCreateBankFrame(bagID)
    local name = "OneWoW_BankContainerFrame" .. bagID
    local frame = _G[name]
    if not frame then
        frame = CreateFrame("Frame", name, UIParent)
        frame:SetID(bagID)
        frame:SetSize(1, 1)
    end
    return frame
end

function BankSet:IsWarband()
    local db = OneWoW_Bags:GetDB()
    return db.global.bankShowWarband
end

function BankSet:GetActiveTabs()
    if self:IsWarband() then
        return BankTypes:GetWarbandTabIDs()
    else
        return BankTypes:GetBankTabIDs()
    end
end

function BankSet:RebuildButtonList()
    wipe(self.buttonList)
    wipe(self.bagRanges)

    for _, bagID in ipairs(self:GetActiveTabs()) do
        local bagSlots = self.slots[bagID]
        if bagSlots then
            local startIndex = #self.buttonList + 1
            local maxSlot = 0
            for slotID in pairs(bagSlots) do
                if slotID > maxSlot then maxSlot = slotID end
            end
            for slotID = 1, maxSlot do
                local button = bagSlots[slotID]
                if button then
                    tinsert(self.buttonList, button)
                end
            end
            if #self.buttonList >= startIndex then
                self.bagRanges[bagID] = { startIndex, #self.buttonList }
            end
        end
    end
end

function BankSet:Build()
    self:ReleaseAll()
    self.totalSlots = 0
    self.freeSlots = 0

    local showWarband = self:IsWarband()
    local bankType = showWarband and Enum.BankType.Account or Enum.BankType.Character
    local numPurchased = C_Bank.FetchNumPurchasedBankTabs(bankType) or 0

    local bagList = self:GetActiveTabs()
    for tabIdx, bagID in ipairs(bagList) do
        local bagFrame = GetOrCreateBankFrame(bagID)
        self.bagContainerFrames[bagID] = bagFrame
        self.slots[bagID] = {}

        if tabIdx <= numPurchased then
            local numSlots = C_Container.GetContainerNumSlots(bagID)
            local masqueKind = showWarband and "warband" or "bank"
            for slotID = 1, numSlots do
                local button = ItemPool:Acquire()
                button:SetParent(bagFrame)
                OneWoW_Bags:ApplyItemButtonMixin(button)
                button:OWB_SetSlot(bagID, slotID)
                self:ApplyBankScripts(button)
                if OneWoW_Bags.Masque then
                    OneWoW_Bags.Masque:SkinItemButton(button, masqueKind)
                end
                self.slots[bagID][slotID] = button
                self.totalSlots = self.totalSlots + 1
            end
        end
    end

    self.isBuilt = true
    self:RebuildButtonList()
    self:UpdateAllSlots()
end

function BankSet:ReleaseAll()
    for _, bagSlots in pairs(self.slots) do
        for _, button in pairs(bagSlots) do
            self:RestoreBankScripts(button)
            ItemPool:Release(button)
        end
    end
    self.slots = {}
    self.bagContainerFrames = {}
    wipe(self.buttonList)
    wipe(self.bagRanges)
    wipe(self._allButtonsScratch)
    wipe(self._bagButtonsScratch)
    self.totalSlots = 0
    self.freeSlots = 0
    self.isBuilt = false
end

function BankSet:UpdateDirtyBags(dirtyBags)
    if not self.isBuilt then return end
    for bagID in pairs(dirtyBags) do
        if self.slots[bagID] then
            local numSlots = C_Container.GetContainerNumSlots(bagID)
            local currentCount = 0
            for _ in pairs(self.slots[bagID]) do currentCount = currentCount + 1 end
            if currentCount ~= numSlots then
                self:RebuildBag(bagID, numSlots)
            else
                for _, button in pairs(self.slots[bagID]) do
                    button:OWB_MarkDirty()
                end
            end
        end
    end
    self:ProcessDirtySlots()
end

function BankSet:RebuildBag(bagID, numSlots)
    if self.slots[bagID] then
        for _, button in pairs(self.slots[bagID]) do
            ItemPool:Release(button)
            self.totalSlots = self.totalSlots - 1
        end
    end

    local bagFrame = GetOrCreateBankFrame(bagID)
    self.bagContainerFrames[bagID] = bagFrame

    self.slots[bagID] = {}
    local masqueKind = self:IsWarband() and "warband" or "bank"
    for slotID = 1, numSlots do
        local button = ItemPool:Acquire()
        button:SetParent(bagFrame)
        OneWoW_Bags:ApplyItemButtonMixin(button)
        button:OWB_SetSlot(bagID, slotID)
        self:ApplyBankScripts(button)
        if OneWoW_Bags.Masque then
            OneWoW_Bags.Masque:SkinItemButton(button, masqueKind)
        end
        button:OWB_MarkDirty()
        self.slots[bagID][slotID] = button
        self.totalSlots = self.totalSlots + 1
    end
    self:RebuildButtonList()
end

function BankSet:ProcessDirtySlots()
    self.freeSlots = 0
    for _, bagSlots in pairs(self.slots) do
        for _, button in pairs(bagSlots) do
            if button:OWB_IsDirty() then
                button:OWB_FullUpdate()
            end
            if not button.owb_hasItem then
                self.freeSlots = self.freeSlots + 1
            end
        end
    end
end

function BankSet:UpdateAllSlots()
    for _, bagSlots in pairs(self.slots) do
        for _, button in pairs(bagSlots) do
            button:OWB_MarkDirty()
        end
    end
    self:ProcessDirtySlots()
end

function BankSet:UpdateSlotsForItems(itemIDs)
    if not self.isBuilt or not itemIDs then return end
    local anyDirty = false
    for _, bagSlots in pairs(self.slots) do
        for _, button in pairs(bagSlots) do
            local info = button.owb_itemInfo
            local id = info and info.itemID
            if id and itemIDs[id] then
                button:OWB_MarkDirty()
                anyDirty = true
            end
        end
    end
    if anyDirty then
        self:ProcessDirtySlots()
    end
end

function BankSet:RefreshAllVisuals()
    self:UpdateAllSlots()
end

function BankSet:UpdateQualityColors()
    for _, bagSlots in pairs(self.slots) do
        for _, button in pairs(bagSlots) do
            local quality = button.owb_itemInfo and button.owb_itemInfo.quality
            if OneWoW_Bags:ShouldShowItemQuality(true, quality) then
                OneWoW_GUI:UpdateIconQuality(button, button.owb_itemInfo.quality)
            else
                OneWoW_GUI:UpdateIconQuality(button, nil)
            end
        end
    end
end

function BankSet:GetAllButtons()
    return CopyRange(self.buttonList, 1, #self.buttonList, self._allButtonsScratch)
end

function BankSet:GetButtonList()
    return self.buttonList
end

function BankSet:GetButtonsByBag(bagID, dest)
    local scratch = dest or self._bagButtonsScratch
    local range = self.bagRanges[bagID]
    return CopyRange(self.buttonList, range and range[1], range and range[2], scratch)
end

function BankSet:ApplyBankScripts(button)
    if button._bankScriptsApplied then return end
    button._bankScriptsApplied = true
    button.owb_isBank = true

    button._bankOrigOnEnter = button:GetScript("OnEnter")
    button._bankOrigOnLeave = button:GetScript("OnLeave")

    button:SetScript("OnEnter", function(myself)
        GameTooltip:SetOwner(myself, "ANCHOR_RIGHT")
        local bagID = myself.owb_bagID
        local slotID = myself.owb_slotID
        if bagID and slotID then
            local info = C_Container.GetContainerItemInfo(bagID, slotID)
            if info and info.hyperlink then
                GameTooltip:SetBagItem(bagID, slotID)
                GameTooltip:Show()
            end
        end
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function BankSet:RestoreBankScripts(button)
    if not button._bankScriptsApplied then return end
    button._bankScriptsApplied = nil
    button.owb_isBank = nil

    button:SetScript("OnEnter", button._bankOrigOnEnter)
    button:SetScript("OnLeave", button._bankOrigOnLeave)
    button._bankOrigOnEnter = nil
    button._bankOrigOnLeave = nil
end

function BankSet:GetSlotCount()
    return self.totalSlots
end

function BankSet:GetFreeSlotCount()
    return self.freeSlots
end
