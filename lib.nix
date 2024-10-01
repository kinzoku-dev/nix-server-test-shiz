{
  lib,
  pkgs,
  ...
}:
lib.extend (
  _: libprev: {
    # namespace for custom functions
    custom = {
      getSSHPubkeys = url: hash: let
        authorizedKeys = pkgs.fetchurl {
          inherit url hash;
        };
      in
        libprev.splitString "\n" (builtins.readFile authorizedKeys);
    };
  }
)
