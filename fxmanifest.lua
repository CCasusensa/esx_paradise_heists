fx_version 'adamant'

game 'gta5'

description 'Paradise Heists by lrenex(modify)'

version '1.1.1'


client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/client.lua',
	'client/fleeca.lua',
	'client/drilling.lua',
	'client/hacking.lua',

	'locales/en.lua',
	'locales/cs.lua',
	'locales/zh.lua'
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/server.lua',

	'locales/en.lua',
	'locales/cs.lua',
	'locales/zh.lua'
}
