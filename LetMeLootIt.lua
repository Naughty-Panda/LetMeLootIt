local addonName = "LetMeLootIt"
local addonVersion = 2
local savedVariables
local defaults = {
	AutoLootGold 			= true,
	AutoLootTelvar 			= false,
	AutoLootWritVouchers 	= false,
	AutoLootAsBank 			= false,
	AutoLootOrnate			= true,
	AutoLootIntricate		= false,
	debugMode				= false,
}

local function CheckForEmptyLoot(unownedMoney, ownedMoney, telvarStones, writVouchers)
	if unownedMoney == 0 and ownedMoney == 0 then
		if telvarStones == 0 and writVouchers == 0 then
			-- Bug fix for empty containers
			local currScene = SCENE_MANAGER:GetCurrentSceneName()
			SCENE_MANAGER:HideCurrentScene()
			SCENE_MANAGER:Show(currScene)
			--SCENE_MANAGER:ShowBaseScene()
		end
	end
end	-- func

local function CheckForTrait(itemLink, itemID)
	local currentTrait = GetItemLinkTraitInfo(itemLink)
	if savedVariables.AutoLootOrnate == true then
		if currentTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE then
			LootItemById(itemID)
		elseif currentTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE then
			LootItemById(itemID)
		elseif currentTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE then
			LootItemById(itemID)
		end
	end	-- if ornate
	if savedVariables.AutoLootIntricate == true then
		if currentTrait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE then
			LootItemById(itemID)
		elseif currentTrait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE then
			LootItemById(itemID)
		end
	end	-- if intricate
end	-- func

local function CheckForCurrency(unownedMoney, ownedMoney, telvarStones, writVouchers)

if defaults.debugMode == true then
d(zo_strformat("AutoLootGold: <<1>>", tostring(savedVariables.AutoLootGold)))
d(zo_strformat("AutoLootTelvar: <<1>>", tostring(savedVariables.AutoLootTelvar)))
d(zo_strformat("AutoLootWritVouchers: <<1>>", tostring(savedVariables.AutoLootWritVouchers)))
end		
	-- Get money settings
	if savedVariables.AutoLootGold == true then	
		-- Not stolen money
		if unownedMoney > 0 then
			LootCurrency(CURT_MONEY)
		end
	end
	-- Get other currency settings
	if savedVariables.AutoLootTelvar == true then
		if telvarStones > 0 then
			LootCurrency(CURT_TELVAR_STONES)
		end
	end
	if savedVariables.AutoLootWritVouchers == true then
		if writVouchers > 0 then
			LootCurrency(CURT_WRIT_VOUCHERS)
		end
	end	
end

local function OnLootUpdated(event)
	-- Check for AutoLoot setting state
	if GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT) == 1 then return end
	
	-- Looking for currency and other items to loot, get CraftBag access
	local unownedMoney, ownedMoney = GetLootCurrency(CURT_MONEY)
	local telvarStones = GetLootCurrency(CURT_TELVAR_STONES)
	local writVouchers = GetLootCurrency(CURT_WRIT_VOUCHERS)
	local num = GetNumLootItems()
	local esoplus = HasCraftBagAccess()

if defaults.debugMode == true then
d(zo_strformat("AutoLootAsBank: <<1>>", tostring(savedVariables.AutoLootAsBank)))
d(zo_strformat("ForceCloseLoot: <<1>>", tostring(savedVariables.forceEndLoot)))
d(zo_strformat("CraftBagAccess: <<1>>", tostring(esoplus)))
d(zo_strformat("Items to loot: <<1>>", num))
end
	
	-- Check for currency and loot it
	CheckForCurrency(unownedMoney, ownedMoney, telvarStones, writVouchers)
	
	-- Check if loot window is empty then close it
	if num == 0 then CheckForEmptyLoot(unownedMoney, ownedMoney, telvarStones, writVouchers) return end
	-- GetLootItemInfo(index)
	-- Returns: lootId, name, textureName icon, count, quality, value, boolean isQuest, boolean stolen, LootItemType
	for index = 1, num do
		local itemID, _, _, _, _, _, _, isStolen, lootItemType = GetLootItemInfo(index)
		local itemLink = GetLootItemLink(itemID, 0)
		-- Do not loot if stolen!
		if isStolen == false then
			-- Loot if stackable
			if IsItemLinkStackable(itemLink) then
				local inBag, inBank, inCraftBag = GetItemLinkStacks(itemLink)
				-- Loot if already exists in CraftBag or Bag
				if esoplus == true then
					if inCraftBag > 0 or inBag > 0 then
						LootItemById(itemID)
					end
				elseif inBag > 0 and DoesBagHaveSpaceForItemLink(1, itemLink) then
					LootItemById(itemID)
				end	-- if CraftBag or Bag
				
				-- Support for banked items
				if savedVariables.AutoLootAsBank == true then
					if inBank > 0 and DoesBagHaveSpaceForItemLink(1, itemLink) then
						LootItemById(itemID)
					end
				end -- if autoloot as bank
			elseif savedVariables.AutoLootOrnate == true or savedVariables.AutoLootIntricate == true then
				if DoesBagHaveSpaceForItemLink(1, itemLink) then
					CheckForTrait(itemLink, itemID)
				end
			end	-- if stackable		
		end	-- if Stolen
	end	-- main for
end	-- OnLootUpdated

local function OnAddonLoaded(event, name)
	if name ~= addonName then return end
	
	-- Let`s initialize saved variables
	savedVariables = ZO_SavedVars:NewAccountWide("LetMeLootIt_SavedVariables", addonVersion, nil, defaults)
	
	-- Creating settings window
	CreateSettingsWindow(savedVariables, defaults, addonName)

EVENT_MANAGER:RegisterForEvent(addonName, EVENT_LOOT_UPDATED, OnLootUpdated)
EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, OnAddonLoaded)