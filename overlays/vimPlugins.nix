{ inputs, lib, ... }:

(final: prev: {
  vimPlugins =
    prev.vimPlugins // {
      centerpad-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "centerpad-nvim";
        name = pname;
        src = inputs.centerpad-nvim;
      };
    };
})
