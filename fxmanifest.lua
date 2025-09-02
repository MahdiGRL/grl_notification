fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'grl_notification'
description 'Modular native feed notifications with cross-resource API'
author 'you'
version '1.0.0'

shared_script 'config.lua'
server_script 'server/main.lua'
client_script 'client/main.lua'

exports {
  -- client-side
  'Show', 'RemoveByKey', 'SetTheme'
}

server_exports {
  -- server-side
  'Notify', 'Broadcast'
}
