{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
  ];

  # Theming
  hm = {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
    };
    catppuccin.cursors.enable = true;

    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = (pkgs.catppuccin-gtk.override {
          accents = [ config.catppuccin.accent ];
          variant = config.catppuccin.flavor;
          size = "standard";
        });
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };
  };
}
