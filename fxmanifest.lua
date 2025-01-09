fx_version 'adamant'

game 'gta5'

description 'A FiveM fingerprint system'
author 'robinapi'
version '1.0'

shared_scripts {
    '@es_extended/imports.lua',
    'shared/cfg_client.lua'
}

server_scripts {
	'server/main.lua',
    'shared/cfg_server.lua'
}

dependency 'es_extended'