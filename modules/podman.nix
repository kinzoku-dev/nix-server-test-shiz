{
  lib,
  config,
  ...
}: {
  options.custom = {
    podman = {
      enable = lib.mkEnableOption "Podman";
    };
  };

  config = lib.mkIf config.custom.podman.enable {
    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;

        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
    };
  };
}
