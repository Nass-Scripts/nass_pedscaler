version '1.0.0'

use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

author 'Nass Scripts'
description 'nass_pedscaler'

ui_page 'web/build/index.html'

files {
    'web/build/app.js',
    'web/build/index.html',
}

shared_scripts {'locale/*.lua', 'config.lua'}

client_scripts {'client/**.lua'}

server_scripts {'server/**.lua'}


escrow_ignore {
    --'**',
    'locale.lua',
    'config.lua',
    'client/unlocked.lua',
    'server/unlocked.lua',
}

fx_version 'cerulean'
