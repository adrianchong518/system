{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.preferences;
in {
  options.modules.darwin.preferences = with types; {
    enableDefaults = mkBoolOpt true;
  };

  config = mkIf cfg.enableDefaults {
    system.defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";

        # finder
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;

        # keyboard
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        # beep
        "com.apple.sound.beep.feedback" = 0;
      };

      # firewall
      alf.globalstate = 1;

      # dock
      dock = {
        orientation = "left";
        tilesize = 45;

        show-process-indicators = true;
        show-recents = false;
        showhidden = true;

        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;

        mineffect = "scale";
        minimize-to-application = true;

        mru-spaces = false;
        expose-animation-duration = 0.1;
      };

      # finder
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # login
      loginwindow = { GuestEnabled = false; };

      # screencapture
      screencapture = {
        disable-shadow = true;
        type = "jpg";
      };

      # magic mouse
      magicmouse.MouseButtonMode = "TwoButton";

      # trackpad
      trackpad = {
        Clicking = true;
        Dragging = true;

        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
      };
    };

    # keyboard
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
