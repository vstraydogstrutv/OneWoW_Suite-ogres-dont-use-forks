-- OneWoW/GUI/t-managefeatures.lua
-- Thin wrapper so the Settings tab can list "Manage Features" alongside
-- Profiles. Actual UI is built in Core/FirstRunWizard.lua and uses only
-- OneWoW_GUI helpers (no raw SetBackdrop / UICheckButtonTemplate).
local ADDON_NAME, OneWoW = ...

local GUI = OneWoW.GUI
local OneWoW_GUI = LibStub("OneWoW_GUI-1.0", true)
if not OneWoW_GUI then return end

function GUI:CreateManageFeaturesTab(parent)
    local L = OneWoW.L
    local _, content = OneWoW_GUI:CreateScrollFrame(parent, { name = "OneWoW_ManageFeaturesLauncherScroll" })

    local hero = OneWoW_GUI:CreateHeroPanel(content, {
        title = L["WIZARD_SETTINGS_TITLE"],
        subtitle = L["WIZARD_SETTINGS_SUBTITLE"],
        description = L["WIZARD_SETTINGS_DESC"],
        calloutText = L["WIZARD_HERO_CALLOUT"],
        iconTexture = OneWoW_GUI:GetBrandIcon(OneWoW_GUI:GetSetting("minimap.theme")),
        yOffset = -10,
    })

    local openBtn = OneWoW_GUI:CreateFitTextButton(content, {
        text = L["WIZARD_OPEN_BUTTON"],
        height = 28,
        minWidth = 140,
    })
    openBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 12, hero.bottomY - 12)
    openBtn:SetScript("OnClick", function()
        OneWoW.FirstRun:ShowWizard()
    end)

    content:SetHeight(math.abs(hero.bottomY) + 70)
end
