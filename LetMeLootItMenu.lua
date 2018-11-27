function CreateSettingsWindow(savedVariables, defaults, addonName)

if addonName ~= "LetMeLootIt" then return end

local LAM = LibStub("LibAddonMenu-2.0")
local panelData = {
    type = "panel",
    name = "Let Me Loot It",
    displayName = ZO_HIGHLIGHT_TEXT:Colorize("Let Me Loot It"),
    author = "Ashi",
    version = "1.1.0",
    registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
    registerForDefaults = true,	--boolean (optional) (will set all options controls back to default values)
}

local optionsTable = {
			[1] = {
				type = "header",
				name = "Currency options",
				width = "full",	--or "half" (optional)
			},
			[2] = {
                type = "checkbox",
                name = "Auto loot Gold",
                tooltip = "Automatically loot Gold if enabled",
                getFunc = function() return savedVariables.AutoLootGold end,
                setFunc = function(state) savedVariables.AutoLootGold = state end,
                width = "full",
				default = defaults.AutoLootGold,
			},
			[3] = {
                type = "checkbox",
                name = "Auto loot Tel Var Stones",
                tooltip = "Automatically loot Tel Var Stones if enabled",
                getFunc = function() return savedVariables.AutoLootTelvar end,
                setFunc = function(state) savedVariables.AutoLootTelvar = state end,
                width = "full",
				default = defaults.AutoLootTelvar,
			},
			[4] = {
                type = "checkbox",
                name = "Auto loot Writ Vouchers",
                tooltip = "Automatically loot Writ Vouchers if enabled",
                getFunc = function() return savedVariables.AutoLootWritVouchers end,
                setFunc = function(state) savedVariables.AutoLootWritVouchers = state end,
                width = "full",
				default = defaults.AutoLootWritVouchers,
			},
			[5] = {
				type = "header",
				name = "Item trait options",
				width = "full",
			},
			[6] = {
                type = "checkbox",
                name = "Take Ornate",
                tooltip = "Automatically take items with Ornate trait",
                getFunc = function() return savedVariables.AutoLootOrnate end,
                setFunc = function(state) savedVariables.AutoLootOrnate = state end,
                width = "half",
				default = defaults.AutoLootOrnate,
			},
			[7] = {
                type = "checkbox",
                name = "Take Intricate",
                tooltip = "Automatically take items with Intricate trait",
                getFunc = function() return savedVariables.AutoLootIntricate end,
                setFunc = function(state) savedVariables.AutoLootIntricate = state end,
                width = "half",
				default = defaults.AutoLootIntricate,
			},			
			[8] = {
				type = "header",
				name = "Source options",
				width = "full",
			},
			[9] = {
                type = "checkbox",
                name = "Bank content",
                tooltip = "Automatically take items that you already have in your bank",
                getFunc = function() return savedVariables.AutoLootAsBank end,
                setFunc = function(state) savedVariables.AutoLootAsBank = state end,
                width = "full",
				default = defaults.AutoLootAsBank,
			},
}

LAM:RegisterAddonPanel("LetMeLootItMenu", panelData)
LAM:RegisterOptionControls("LetMeLootItMenu", optionsTable)
end