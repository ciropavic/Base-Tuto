-----------------------------------------
-- Created and modify by L'ile Légale RP
-- SenSi and Kaminosekai
-----------------------------------------
ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local vine, jus = 1, 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'vigne', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'vigne', _U('vigneron_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'vigne', 'Vigneron', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "RaisinFarm" then
			local itemQuantity = xPlayer.getInventoryItem('raisin').count
			if itemQuantity >= 100 then
				xPlayer.showNotification(_U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('raisin', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_vigneronjob:startHarvest')
AddEventHandler('esx_vigneronjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopHarvest')
AddEventHandler('esx_vigneronjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementVin" then
			local itemQuantity = xPlayer.getInventoryItem('raisin').count

			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_raisin'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('raisin', 1)
						xPlayer.addInventoryItem('grand_cru', 1)
						xPlayer.showNotification(_U('grand_cru'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('raisin', 1)
						xPlayer.addInventoryItem('vine', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem('raisin').count
			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_raisin'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('raisin', 1)
					xPlayer.addInventoryItem('jus_raisin', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_vigneronjob:startTransform')
AddEventHandler('esx_vigneronjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopTransform')
AddEventHandler('esx_vigneronjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre raisin')
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('vine').count <= 0 then
				vine = 0
			else
				vine = 1
			end
			
			if xPlayer.getInventoryItem('jus_raisin').count <= 0 then
				jus = 0
			else
				jus = 1
			end

			if xPlayer.getInventoryItem('grand_cru').count <= 0 then
				gc = 0
			else
				gc = 1
			end
		
			if vine == 0 and jus == 0 and gc == 0 then
				xPlayer.showNotification(_U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('vine').count <= 0 and jus == 0 and gc == 0 then
				xPlayer.showNotification(_U('no_vin_sale'))
				vine = 0
				return
			elseif xPlayer.getInventoryItem('jus_raisin').count <= 0 and vine == 0 and gc == 0 then
				xPlayer.showNotification(_U('no_jus_sale'))
				jus = 0
				return
			elseif xPlayer.getInventoryItem('grand_cru').count <= 0 and vine == 0 and jus == 0 then
				xPlayer.showNotification(_U('no_jus_sale'))
				jus = 0
				return
			else
				if (jus == 1) then
					SetTimeout(1100, function()
						local money = math.random(18,25)
						xPlayer.removeInventoryItem('jus_raisin', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (vine == 1) then
					SetTimeout(1100, function()
						local money = math.random(30,35)
						xPlayer.removeInventoryItem('vine', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (gc == 1) then
					SetTimeout(25000, function()
						local money = 275
						local tItt = xPlayer.getInventoryItem('grand_cru').count

						local totalPrice = money * tItt

						xPlayer.removeInventoryItem('grand_cru', tItt)

						xPlayer.addAccountMoney('money', (totalPrice*0.15))
						xPlayer.showNotification(('vous avez obtenu une commison de %s $ car vous avez vendu %s ~y~Grand Cru'):format((totalPrice*0.15), tItt))

						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(totalPrice)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. totalPrice)
						end
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_vigneronjob:startSell')
AddEventHandler('esx_vigneronjob:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopSell')
AddEventHandler('esx_vigneronjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

RegisterNetEvent('esx_vigneronjob:getStockItem')
AddEventHandler('esx_vigneronjob:getStockItem', function(itemName, count)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.name))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

RegisterNetEvent('esx_vigneronjob:putStockItems')
AddEventHandler('esx_vigneronjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vigneronjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vigneronjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)
