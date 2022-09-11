fx_version 'adamant'

game 'gta5'

description 'ESX Vehicle Lock'

version 'legacy'

shared_script '@es_extended/imports.lua'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/imports.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'
