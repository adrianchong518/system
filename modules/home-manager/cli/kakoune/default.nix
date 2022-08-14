{ config, pkgs, lib, ... }:

{
  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "default";

      numberLines = {
        enable = true;
        highlightCursor = true;
      };

      scrollOff = {
        lines = 5;
        columns = 10;
      };

      ui = {
        enableMouse = true;
        assistant = "none";
      };

      hooks = [
        {
          name = "WinSetOption";
          option = "filetype=markdown";
          commands = ''
            set window autowrap_column 80
            autowrap-enable

            addhl window/ column 81 default,rgb:404040
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=nix";
          commands = ''
            set window indentwidth 2
          '';
        }
      ];

      keyMappings = [
        {
          mode = "user";
          key = "w";
          effect = ":echo %sh{wc -w <lt><lt><lt> \"\${kak_selection}\"}<ret>";
          docstring = "Word count in selection";
        }
      ];
    };

    # extraConfig = ''
    #   eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
    #   lsp-enable
    # '';

    # plugins = with pkgs.kakounePlugins; [
    #     kak-lsp
    #     kak-auto-pairs
    # ];
  };
}
