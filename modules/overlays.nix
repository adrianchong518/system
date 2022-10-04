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
    (final: prev:
      let
        todo-comments-nvim = prev.vimUtils.buildVimPlugin rec {
          pname = "todo-comments-nvim";
          name = pname;
          src = inputs.todo-comments-nvim;
        };
      in
      {
        vimPlugins =
          prev.vimPlugins // {
            inherit todo-comments-nvim;
          };
      }
    )
  ];
}
