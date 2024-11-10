-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Core RP framework for Desync'
author 'Braanflakes'
version '1.0.0'

shared_scripts {
  'config.lua'
}

client_scripts {
  'client/*.lua'
}

server_scripts {
  'server/classes/*.lua',
  'server/*.lua',
  '@oxmysql/lib/MySQL.lua'
}

dependencies {
  'oxmysql'
}