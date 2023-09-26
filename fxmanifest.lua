fx_version 'cerulean'
game 'gta5'
author "Pb"

lua54 'yes'

files {
    'locales/*.json'
}

shared_scripts {
    '@pb-utils/init.lua',
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
    'pb-utils',
}
