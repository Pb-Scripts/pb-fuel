fx_version 'cerulean'
game 'gta5'
author "Pb"

lua54 'yes'

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'ox_lib',
}