local BlackAccountsIndex, BlackAccounts, SharedBlackAccounts = {}, {}, {}

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local accounts = MySQL.query.await('SELECT * FROM addon_black_account LEFT JOIN addon_black_account_data ON addon_black_account.name = addon_black_account_data.account_name UNION SELECT * FROM addon_black_account RIGHT JOIN addon_black_account_data ON addon_black_account.name = addon_black_account_data.account_name')

		local newBlackAccounts = {}
		for i = 1, #accounts do
			local account = accounts[i]
			if account.shared == 0 then
				if not BlackAccounts[account.name] then
					BlackAccountsIndex[#BlackAccountsIndex + 1] = account.name
					BlackAccounts[account.name] = {}
				end
				BlackAccounts[account.name][#BlackAccounts[account.name] + 1] = CreateAddonBlackAccount(account.name, account.owner, account.money)
			else
				if account.money then
					SharedBlackAccounts[account.name] = CreateAddonBlackAccount(account.name, nil, account.money)
				else
					newBlackAccounts[#newBlackAccounts + 1] = {account.name, 0}
				end
			end
		end

		if next(newBlackAccounts) then
			MySQL.prepare('INSERT INTO addon_black_account_data (account_name, money) VALUES (?, ?)', newBlackAccounts)
			for i = 1, #newBlackAccounts do
				local newAccount = newBlackAccounts[i]
				SharedBlackAccounts[newAccount[1]] = CreateAddonBlackAccount(newAccount[1], nil, 0)
			end
		end
	end
end)

function GetBlackAccount(name, owner)
	for i=1, #BlackAccounts[name], 1 do
		if BlackAccounts[name][i].owner == owner then
			return BlackAccounts[name][i]
		end
	end
end

function GetSharedBlackAccount(name)
	return SharedBlackAccounts[name]
end

AddEventHandler('esx_addonblackaccount:getBlackAccount', function(name, owner, cb)
	cb(GetBlackAccount(name, owner))
end)

AddEventHandler('esx_addonblackaccount:getSharedBlackAccount', function(name, cb)
	cb(GetSharedBlackAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonBlackAccounts = {}

	for i=1, #BlackAccountsIndex, 1 do
		local name    = BlackAccountsIndex[i]
		local account = GetAccount(name, xPlayer.identifier)

		if account == nil then
			MySQL.insert('INSERT INTO addon_black_account_data (account_name, money, owner) VALUES (?, ?, ?)', {name, 0, xPlayer.identifier})

			account = CreateAddonBlackAccount(name, xPlayer.identifier, 0)
			BlackAccounts[name][#BlackAccounts[name] + 1] = account
		end

		addonBlackAccounts[#addonBlackAccounts + 1] = account
	end

	xPlayer.set('addonBlackAccounts', addonBlackAccounts)
end)
