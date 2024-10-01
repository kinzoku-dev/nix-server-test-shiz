{
  pkgs,
  config,
  ...
}: {
  packages = [
    pkgs.nixops_unstable_minimal
    pkgs.nixos-anywhere
    (pkgs.writeShellScriptBin "devenvGreet" ''
      echo "Now in Devenv"
      echo ""
      echo "Files:"
      echo "- flake.nix : Nix Flake file"
      echo "- flake.lock : Nix Flake lock file"
      echo "- devenv.nix : Devenv configuration file"
    '')
  ];

  enterShell = ''
    devenvGreet
  '';

  dotenv.enable = true;
}
