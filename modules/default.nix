lib:

let
  walk-dir =
    path:
    let
      dir = builtins.readDir path;
    in
    lib.mapAttrs' (name: value: {
      name = lib.removeSuffix ".nix" name;
      value =
        if value == "regular" then
          import (path + "/${name}")
        else if value == "directory" then
          walk-dir (path + "/${name}")
        else
          builtins.throw "Items of type ${value} are unsupported.";
    }) dir;
in
walk-dir ./.
