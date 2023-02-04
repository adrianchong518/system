(hs.ipc.cliInstall)

(hs.hotkey.bind
  [:cmd :alt :ctrl] "w" nil
  (fn [] (hs.alert.show "Hello World!")))
