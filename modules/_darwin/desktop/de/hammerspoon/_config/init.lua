require 'hs.ipc'
hs.ipc.cliInstall()

hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'W', function()
    hs.alert.show('Hello')
end)
