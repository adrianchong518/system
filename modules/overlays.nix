{ inputs, lib, ... }:

{
  nixpkgs.overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import inputs.stable { system = prev.system; };
      small = import inputs.small { system = prev.system; };
    })

    # vimPlugins
    (final: prev: {
      vimPlugins =
        prev.vimPlugins // {
          todo-comments-nvim = prev.vimUtils.buildVimPlugin rec {
            pname = "todo-comments-nvim";
            name = pname;
            src = inputs.todo-comments-nvim;
          };
          centerpad-nvim = prev.vimUtils.buildVimPlugin rec {
            pname = "centerpad-nvim";
            name = pname;
            src = inputs.centerpad-nvim;
          };
        };
    }
    )
  ];
}
