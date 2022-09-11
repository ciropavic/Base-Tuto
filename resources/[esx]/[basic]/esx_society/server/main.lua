local Jobs = {}
local RegisteredSocieties = {}

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local result = MySQL.query.await('SELECT * FROM jobs')

		for i = 1, #result, 1 do
			Jobs[result[i].name] = result[i]
			Jobs[result[i].name].grades = {}
		end

		local result2 = MySQL.query.await('SELECT * FROM job_grades')

		for i = 1, #result2, 1 do
			Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		end
	end
end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found, RegisteredSocieties[i] = true, society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))
	local nJob, plName

	if xPlayer.job.name == society.name then 
		nJob = xPlayer.job.name
	elseif xPlayer.job2.name == society.name then 
		nJob = xPlayer.job2.name
	end


	if (xPlayer.job.name == society.name or xPlayer.job2.name == society.name) then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)
				xPlayer.showNotification(_U('have_withdrawn', ESX.Math.GroupDigits(amount)))

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier ', {
					['@identifier'] = xPlayer.identifier
				}, function (results)
					for i=1, #results, 1 do
						plName       = results[i].firstname .. ' ' .. results[i].lastname
					end
					sendToDiscord('Retrait Argent Propre', nJob,'Retrait du coffre effectuée : '..amount..' $\nIdantifiant : '.. xPlayer.identifier ..'\nNom & Prénom : '.. plName )
				end)

			else
				xPlayer.showNotification(_U('invalid_amount'))
			end
		end)
	else
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))
	local nJob, plName

	if xPlayer.job.name == society.name then 
		nJob = xPlayer.job.name
	elseif xPlayer.job2.name == society.name then 
		nJob = xPlayer.job2.name
	end

	if (xPlayer.job.name == society.name or xPlayer.job2.name == society.name) then
		if amount > 0 and xPlayer.getMoney() >= amount then
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeMoney(amount)
				xPlayer.showNotification(_U('have_deposited', ESX.Math.GroupDigits(amount)))
				account.addMoney(amount)
			end)

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier ', {
					['@identifier'] = xPlayer.identifier
				}, function (results)
					for i=1, #results, 1 do
						plName       = results[i].firstname .. ' ' .. results[i].lastname
					end
					sendToDiscord('Depot Argent Propre', nJob,'Depot effectuée : '..amount..' $\nIdantifiant : '.. xPlayer.identifier ..'\nNom & Prénom : '.. plName )
				end)

		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:withdrawBlackMoney')
AddEventHandler('esx_society:withdrawBlackMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))
	local nJob, plName

	if xPlayer.job.name == society.name then 
		nJob = xPlayer.job.name
	elseif xPlayer.job2.name == society.name then 
		nJob = xPlayer.job2.name
	end

	if (xPlayer.job.name == society.name or xPlayer.job2.name == society.name) then
		TriggerEvent('esx_addonblackaccount:getSharedBlackAccount', society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addAccountMoney('black_money', amount)
				xPlayer.showNotification(_U('have_withdrawn', ESX.Math.GroupDigits(amount)))

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier ', {
					['@identifier'] = xPlayer.identifier
				}, function (results)
					for i=1, #results, 1 do
						plName       = results[i].firstname .. ' ' .. results[i].lastname
					end
					sendToDiscord('Retrait Argent Sale', nJob,'Retrait du coffre effectuée : '..amount..' $\nIdantifiant : '.. xPlayer.identifier ..'\nNom & Prénom : '.. plName )
				end)
			else
				xPlayer.showNotification(_U('invalid_amount'))
			end
		end)
	else
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:depositBlackMoney')
AddEventHandler('esx_society:depositBlackMoney', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))
	local nJob, plName

	if xPlayer.job.name == society.name then 
		nJob = xPlayer.job.name
	elseif xPlayer.job2.name == society.name then 
		nJob = xPlayer.job2.name
	end

	if (xPlayer.job.name == society.name or xPlayer.job2.name == society.name) then
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			TriggerEvent('esx_addonblackaccount:getSharedBlackAccount', society.account, function(account)
				xPlayer.removeAccountMoney('black_money', amount)
				xPlayer.showNotification(_U('have_deposited', ESX.Math.GroupDigits(amount)))
				account.addMoney(amount)
			end)

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier ', {
					['@identifier'] = xPlayer.identifier
				}, function (results)
					for i=1, #results, 1 do
						plName       = results[i].firstname .. ' ' .. results[i].lastname
					end
					sendToDiscord('Depot Argent Sale', nJob,'Depot effectuée : '..amount..' $\nIdantifiant : '.. xPlayer.identifier ..'\nNom & Prénom : '.. plName )
				end)
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))
	local nJob, plName

	if xPlayer.job.name == society.name then 
		nJob = xPlayer.job.name
	elseif xPlayer.job2.name == society.name then 
		nJob = xPlayer.job2.name
	end

	if (xPlayer.job.name == society or xPlayer.job2.name == society) then
		if amount and amount > 0 and account.money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)

			MySQL.insert('INSERT INTO society_moneywash (identifier, society, amount) VALUES (?, ?, ?)', {xPlayer.identifier, society, amount},
			function(rowsChanged)
				xPlayer.showNotification(_U('you_have', ESX.Math.GroupDigits(amount)))
			end)

				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier ', {
					['@identifier'] = xPlayer.identifier
				}, function (results)
					for i=1, #results, 1 do
						plName       = results[i].firstname .. ' ' .. results[i].lastname
					end
					sendToDiscord('Blanchiement', nJob,'Montant Blanchie : '..amount..' $\nIdantifiant : '.. xPlayer.identifier ..'\nNom & Prénom : '.. plName )
				end)
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	local employees = {}

	local xPlayers = ESX.GetExtendedPlayers('job', society)
	for _, xPlayer in pairs(xPlayers) do

		local name = xPlayer.name
		if Config.EnableESXIdentity and name == GetPlayerName(xPlayer.source) then
			name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
		end

		table.insert(employees, {
			name = name,
			identifier = xPlayer.identifier,
			job = {
				name = society,
				label = xPlayer.job.label,
				grade = xPlayer.job.grade,
				grade_name = xPlayer.job.grade_name,
				grade_label = xPlayer.job.grade_label
			}
		})
	end
		
	local query = "SELECT identifier, job_grade FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"

	if Config.EnableESXIdentity then
		query = "SELECT identifier, job_grade, firstname, lastname FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"
	end

	MySQL.query(query, {society},
	function(result)
		for k, row in pairs(result) do
			local alreadyInTable
			local identifier = row.identifier

			for k, v in pairs(employees) do
				if v.identifier == identifier then
					alreadyInTable = true
				end
			end

			if not alreadyInTable then
				local name = "Name not found." -- maybe this should be a locale instead ¯\_(ツ)_/¯

				if Config.EnableESXIdentity then
					name = row.firstname .. ' ' .. row.lastname 
				end
				
				table.insert(employees, {
					name = name,
					identifier = identifier,
					job = {
						name = society,
						label = Jobs[society].label,
						grade = row.job_grade,
						grade_name = Jobs[society].grades[tostring(row.job_grade)].name,
						grade_label = Jobs[society].grades[tostring(row.job_grade)].label
					}
				})
			end
		end

		cb(employees)
	end)

end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				xTarget.showNotification(_U('you_have_been_hired', job))
			elseif type == 'promote' then
				xTarget.showNotification(_U('you_have_been_promoted'))
			elseif type == 'fire' then
				xTarget.showNotification(_U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {job, grade, identifier},
			function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		if salary <= Config.MaxSalary then
			MySQL.update('UPDATE job_grades SET salary = ? WHERE job_name = ? AND grade = ?', {salary, job, grade},
			function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary

				local xPlayers = ESX.GetExtendedPlayers('job', job)
				for _, xTarget in pairs(xPlayers) do

					if xTarget.job.grade == grade then
						xTarget.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(xPlayer.identifier))
		cb()
	end
end)

local getOnlinePlayers, onlinePlayers = false, {}
ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	if getOnlinePlayers == false and next(onlinePlayers) == nil then -- Prevent multiple xPlayer loops from running in quick succession
		getOnlinePlayers, onlinePlayers = true, {}
		
		local xPlayers = ESX.GetExtendedPlayers()
		for _, xPlayer in pairs(xPlayers) do
			table.insert(onlinePlayers, {
				source = xPlayer.source,
				identifier = xPlayer.identifier,
				name = xPlayer.name,
				job = xPlayer.job,
				job2 = xPlayer.job2
			})
		end
		cb(onlinePlayers)
		getOnlinePlayers = false
		Wait(1000) -- For the next second any extra requests will receive the cached list
		onlinePlayers = {}
		return
	end
	while getOnlinePlayers do Wait(0) end -- Wait for the xPlayer loop to finish
	cb(onlinePlayers)
end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	MySQL.query('SELECT * FROM society_moneywash', function(result)
		for i=1, #result, 1 do
			local society = GetSociety(result[i].society)
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			if xPlayer then
				xPlayer.showNotification(_U('you_have_laundered', ESX.Math.GroupDigits(result[i].amount)))
			end

		end
		MySQL.update('DELETE FROM society_moneywash')
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)


-- JOb 2
ESX.RegisterServerCallback('esx_society:getEmployees2', function(source, cb, society)
	local employees = {}

	local xPlayers = ESX.GetExtendedPlayers('job2', society)
	for _, xPlayer in pairs(xPlayers) do

		local name = xPlayer.name
		if Config.EnableESXIdentity and name == GetPlayerName(xPlayer.source) then
			name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
		end

		table.insert(employees, {
			name = name,
			identifier = xPlayer.identifier,
			job2 = {
				name = society,
				label = xPlayer.job2.label,
				grade = xPlayer.job2.grade,
				grade_name = xPlayer.job2.grade_name,
				grade_label = xPlayer.job2.grade_label
			}
		})
	end
		
	local query = "SELECT identifier, job2_grade FROM `users` WHERE `job2`= ? ORDER BY job2_grade DESC"

	if Config.EnableESXIdentity then
		query = "SELECT identifier, job2_grade, firstname, lastname FROM `users` WHERE `job2`= ? ORDER BY job2_grade DESC"
	end

	MySQL.query(query, {society},
	function(result)
		for k, row in pairs(result) do
			local alreadyInTable
			local identifier = row.identifier

			for k, v in pairs(employees) do
				if v.identifier == identifier then
					alreadyInTable = true
				end
			end

			if not alreadyInTable then
				local name = "Name not found." -- maybe this should be a locale instead ¯\_(ツ)_/¯

				if Config.EnableESXIdentity then
					name = row.firstname .. ' ' .. row.lastname 
				end
				
				table.insert(employees, {
					name = name,
					identifier = identifier,
					job2 = {
						name = society,
						label = Jobs[society].label,
						grade = row.job2_grade,
						grade_name = Jobs[society].grades[tostring(row.job2_grade)].name,
						grade_label = Jobs[society].grades[tostring(row.job2_grade)].label
					}
				})
			end
		end

		cb(employees)
	end)

end)

ESX.RegisterServerCallback('esx_society:getJob2', function(source, cb, society)
	local job2 = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job2.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job2.grades = grades

	cb(job2)
end)

ESX.RegisterServerCallback('esx_society:setJob2', function(source, cb, identifier, job2, grade2, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job2.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob2(job2, grade2)

			if type == 'hire' then
				xTarget.showNotification(_U('you_have_been_hired_job2', job2))
			elseif type == 'promote' then
				xTarget.showNotification(_U('you_have_been_promoted'))
			elseif type == 'fire' then
				xTarget.showNotification(_U('you_have_been_fired_job2', xTarget.getJob2().label))
			end

			cb()
		else
			MySQL.update('UPDATE users SET job2 = ?, job2_grade = ? WHERE identifier = ?', {job2, grade2, identifier},
			function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob2'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setJobSalary2', function(source, cb, job2, grade2, salary)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job2.name == job2 and xPlayer.job2.grade_name == 'boss' then
		if salary <= Config.MaxSalary then
			MySQL.update('UPDATE job_grades SET salary = ? WHERE job_name = ? AND grade = ?', {salary, job2, grade2},
			function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary

				local xPlayers = ESX.GetExtendedPlayers('job2', job2)
				for _, xTarget in pairs(xPlayers) do

					if xTarget.job2.grade == grade2 then
						xTarget.setJob2(job2, grade2)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary2 over config limit!'):format(xPlayer.identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary2'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:isBoss2', function(source, cb, job2)
	cb(isPlayerBoss2(source, job2))
end)

function isPlayerBoss2(playerId, job2)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job2.name == job2 and xPlayer.job2.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function sendToDiscord(name,message,text,color)
	local DiscordWebHook = 'https://discord.com/api/webhooks/998865534626045952/5yprf0wkhxYbfh33DeET18H-Egc8ahUveVWb-HQkKk-QlaQ3RVKdQz9C6p6gM3xVZxwG'
	local embeds = {
		{
			["title"]=message,
			["description"]=text,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= os.date("%d/%m/%Y %H:%M:%S"),
		   },
		}
	}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end