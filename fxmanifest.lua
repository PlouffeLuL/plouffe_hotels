fx_version "adamant"
lua54 'yes'
use_fxv2_oal 'yes'

games { 'gta5'}

client_scripts {
	'configs/clientConfig.lua',
    'client/*.lua'
}

server_scripts {
	'configs/serverConfig.lua',
    'server/*.lua'
}

dependencies {
    "plouffe_lib"
}