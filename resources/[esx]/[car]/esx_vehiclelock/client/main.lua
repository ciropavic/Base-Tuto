local playerCars = {}

--Menu Mes clés
RegisterNetEvent('esx_vehiclelock:key')
AddEventHandler('esx_vehiclelock:key', function()
ESX.TriggerServerCallback('esx_vehiclelock:allkey', function(mykey)
	local elements = {}
		for i=1, #mykey, 1 do
			if mykey[i].got == 'true' then 
				if 	mykey[i].NB == 1 then									
						table.insert(elements, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
					elseif mykey[i].NB == 2 then
						table.insert(elements, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
					end
				end
			end

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'mykey',
	{
		title = 'Mes clés',
		css = 'carkeys',
		elements = elements
	  },
        function(data2, menu2) --Submit Cb
 
        if data2.current.value ~= nil then
        ESX.UI.Menu.CloseAll()
  			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'mykey',
				{
				title = 'Voulez vous ?',
				align = 'top-left',
				elements = {
						{label = 'Donner', value = 'donnerkey'}, -- Donné les clés
						{label = 'Préter', value = 'preterkey'}, -- Donné les clés
			  		},
	  			},
        		function(data3, menu3) --Submit Cb
 					local player, distance = ESX.Game.GetClosestPlayer()
 					local playerPed = GetPlayerPed(-1)
					local coords    = GetEntityCoords(playerPed, true)
 					local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
 					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

       				 if data3.current.value == 'donnerkey' then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then
       					  TriggerServerEvent('esx_vehiclelock:donnerkey', GetPlayerServerId(player), data2.current.value)
       					  TriggerServerEvent('esx_vehiclelock:deletekey', data2.current.value)
       					  --print("avant changement owner")
       					  TriggerServerEvent('esx_vehiclelock:changeowner', GetPlayerServerId(player), vehicleProps)
       					  --print("après changement owner")
       					end
      				 end
      				 if data3.current.value == 'preterkey' then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then 
       					  TriggerServerEvent('esx_vehiclelock:preterkey', GetPlayerServerId(player), data2.current.value)
       					end
      				 end
       			 end,
       			 function(data3, menu3) --Cancel Cb
           		     menu3.close()
       			 end,
       			 function(data3, menu3) --Change Cb
         
        		 end
   			 )
        end
        end,
        
        function(data2, men2) --Cancel Cb
                men2.close()
        end,
        function(dat2, men2) --Change Cb
        end
      )
  end)
end)


function OpenCloseVehicle()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed, true)

	local vehicle = nil

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('esx_vehiclelock:mykey', function(gotkey)

		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 or locked == 0 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end
		else
			ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 303) then -- Touche U
			OpenCloseVehicle()
		end
	end
end)