{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  networking = {
    hostName = "URSA-MAJOR";
    hostId = "c17fdbc9";
    networkmanager.enable = true;
  };
  systemd = {
    services.NetworkManager-wait-online.enable = false;
  };

  time.timeZone = "America/Chicago";

  # Select i18n properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    consoleLogLevel = 1;
    supportedFilesystems = ["zfs"];
  };

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
  };
  services = {
    udev.enable = true;
    webdav.enable = true;
  };

  custom = {
    podman.enable = true;
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
      RUST_BACKTRACE = "1";
    };

    systemPackages = map lib.lowPrio [
      pkgs.curl
      pkgs.gitMinimal
      pkgs.zsh
      pkgs.neovim

      pkgs.dive
      pkgs.podman-tui
      pkgs.podman-compose
    ];
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    builders-use-substitutes = true;
    # substituters to use
    substituters = [
      "https://ezkea.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://kinzokudev.cachix.org"
    ];

    trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "kinzokudev.cachix.org-1:MQi8YXI+gNuuKOxz1+bDYBvJdTOM38FX23As0gbL8GM="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  users.users = {
    kinzoku = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };
  };

  system.stateVersion = "24.05";
}
