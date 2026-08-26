fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SINCO'
description 'SINCO anti-cheat'
version '1.0.0'
shared_scripts {
    'init.lua',
    'tables/*.lua',
    'cfg/config.lua'
}

client_scripts {
    'src/cl_detections.lua'
}

server_scripts {
    'src/sv_detections.lua'
}

exports {
    'SINCO_CHANGE_TEMP_WHITELIST',
    'SINCO_CHECK_TEMP_WHITELIST',
    'SINCO_ACTION',
    'Punish',
    'SetTempWhitelist',
    'IsTempWhitelisted'
}

server_exports {
    'SINCO_CHANGE_TEMP_WHITELIST',
    'SINCO_CHECK_TEMP_WHITELIST',
    'SINCO_ACTION',
    'SINCO_BAN_PLAYER',
    'BanPlayer',
    'Punish',
    'SetTempWhitelist',
    'IsTempWhitelisted'
}

dependencies {
    'sinco-core'
}
