local spawnedMeths = 0
local methPlants = {}
local isPickingUpMeth, isProcessingMeth = false, false

CreateThread(function()
	while true do
		Wait(700)
		local coords = GetEntityCoords(PlayerPedId())

		if #(coords - Config.CircleZones.MethField.coords) < 50 then
			SpawnMethPlants()
		end
	end
end)

CreateThread(function()
	while true do
		local wait = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if #(coords - Config.CircleZones.MethProcessing.coords) < 1 then
			wait = 2
			if not isProcessingMeth then
				ESX.ShowHelpNotification(_U('meth_processprompt'))
			end

			if IsControlJustReleased(0, 38) and not isProcessingMeth then
				ESX.TriggerServerCallback('esx_drugs:meth_count', function(xMeth)
					if Config.LicenseEnable then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
							if hasProcessingLicense then
								ProcessMeth(xMeth)
							else
								OpenBuyLicenseMenu('meth_processing')
							end
						end, GetPlayerServerId(PlayerId()), 'meth_processing')
					else
						ProcessMeth(xMeth)
					end
				end)
			end
		end
		Wait(wait)
	end
end)

function ProcessMeth(xMeth)
	isProcessingMeth = true
	ESX.ShowNotification(_U('meth_processingstarted'))
  TriggerServerEvent('esx_drugs:processMeth')
	if(xMeth <= 3) then
		xMeth = 0
	end
  local timeLeft = (Config.Delays.MethProcessing * xMeth) / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Wait(1000)
		timeLeft = timeLeft - 1

		if #(GetEntityCoords(playerPed) - Config.CircleZones.MethProcessing.coords) > 1.5 then
			ESX.ShowNotification(_U('meth_processingtoofar'))
			TriggerServerEvent('esx_drugs:cancelProcessing')
			TriggerServerEvent('esx_drugs:outofbound')
			break
		end
	end

	isProcessingMeth = false
end

CreateThread(function()
	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #methPlants, 1 do
			if #(coords - GetEntityCoords(methPlants[i])) < 1.5 then
				nearbyObject, nearbyID = methPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUpMeth then
				ESX.ShowHelpNotification(_U('meth_pickupprompt'))
			end

			if IsControlJustReleased(0, 38) and not isPickingUpMeth then
				isPickingUpMeth = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)
					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Wait(2000)
						ClearPedTasks(playerPed)
						Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(methPlants, nearbyID)
						spawnedMeths = spawnedMeths - 1
		
						TriggerServerEvent('esx_drugs:pickedUpMeth')
					else
						ESX.ShowNotification(_U('meth_inventoryfull'))
					end

					isPickingUpMeth = false
				end, 'meth')
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(methPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnMethPlants()
	while spawnedMeths < 25 do
		Wait(0)
		local methCoords = GenerateMethCoords()

		ESX.Game.SpawnLocalObject('hei_prop_drug_statue_01', methCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(methPlants, obj)
			spawnedMeths = spawnedMeths + 1
		end)
	end
end

function ValidateMethCoord(plantCoord)
	if spawnedMeths > 0 then
		local validate = true

		for k, v in pairs(methPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(plantCoord - Config.CircleZones.MethField.coords) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMethCoords()
	while true do
		Wait(0)

		local methCoordX, methCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-15, 15)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-15, 15)

		methCoordX = Config.CircleZones.MethField.coords.x + modX
		methCoordY = Config.CircleZones.MethField.coords.y + modY

		local coordZ = GetCoordZMeth(methCoordX, methCoordY)
		local coord = vector3(methCoordX, methCoordY, coordZ)

		if ValidateMethCoord(coord) then
			return coord
		end
	end
end

function GetCoordZMeth(x, y)
	--local groundCheckHeights = { 8.5, 8.75, 9.0, 9.25, 9.5, 9.75, 10.0, 10.25, 10.5, 10.75, 11.0, 11.25, 11.5 }
	local groundCheckHeights = { 30.75, 31.0, 31.25, 31.5, 31.75, 32.0, 32.25 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.63
end
