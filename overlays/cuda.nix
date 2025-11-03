{ ... }:

(final: prev: {
  _cuda = prev._cuda.extend (
    _: prevAttrs: {
      extensions = prevAttrs.extensions ++ [
        (_: p: {
          # cuda_compat = p.cuda_compat.overrideAttrs (_: {
          #   dontUnpack = true;
          #   dontPatch = true;
          # });
          cuda_compat = null;
        })
      ];
    }
  );
})
