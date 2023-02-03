{ lib, ... }:

with builtins;
with lib;
rec {
  # attrsToList
  attrsToList = attrs:
    mapAttrsToList (name: value: { inherit name value; }) attrs;

  # mapListToAttrs :: (a -> { name = String; values = any }) -> [a] -> AttrSet
  mapListToAttrs = f: values:
    listToAttrs (map f values);

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = f: vaules: listToAttrs (map f values);

  # anyAttrs :: (name -> value -> bool) attrs
  anyAttrs = pred: attrs:
    any (attr: pred attr.name attr.value) (attrsToList attrs);

  anyAttrs' = pred: attrs:
    any (attr: if isAttrs attr.value then anyAttrs' pred attr.value else pred attr.name attr.value) (attrsToList attrs);

  # countAttrs :: (name -> value -> bool) attrs
  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);
}
