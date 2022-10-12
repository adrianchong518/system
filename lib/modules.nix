{ self, lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in
rec {
  mapModules = fn: dir:
    mapModules' (name: path: nameValuePair name (fn path)) dir;

  mapModules' = fn: dir:
    mapFilterAttrs
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}";
        in
        if v == "directory" && pathExists "${path}/default.nix"
        then fn n path
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
        then fn (removeSuffix ".nix" n) path
        else nameValuePair "" null)
      (readDir dir);

  mapModulesList = fn: dir:
    attrValues (mapModules fn dir);

  mapModulesRec = fn: dir:
    mapFilterAttrs
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in
        if v == "directory"
        then nameValuePair n (mapModulesRec fn path)
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  mapModulesListRec = fn: dir:
    let
      dirs =
        mapAttrsToList
          (k: _: "${dir}/${k}")
          (filterAttrs
            (n: v: v == "directory" && !(hasPrefix "_" n))
            (readDir dir));
      files = mapModules id dir;
      paths = files ++ concatLists (map (d: mapModulesListRec id d) dirs);
    in
    map fn paths;
}
