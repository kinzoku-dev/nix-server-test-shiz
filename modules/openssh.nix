{
  config,
  lib,
  username,
  ...
}: {
  options.custom = {
    openssh = {
      enable =
        lib.mkEnableOption "OpenSSH"
        // {
          default = true;
        };
    };
  };

  config = lib.mkIf config.custom.openssh.enable {
    services.openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    users.users = {
      root.openssh.authorizedKeys.keys = lib.nebula.getSSHPubkeys "https://github.com/kinzoku-dev.keys" "0jd8fp4qw9wnhw0iw0dp7riid5pcxfy07d17mp0z53cvzfrbqkh1";
      ${username}.openssh.authorizedKeys.keys = lib.nebula.getSSHPubkeys "https://github.com/kinzoku-dev.keys" "0jd8fp4qw9wnhw0iw0dp7riid5pcxfy07d17mp0z53cvzfrbqkh1";
    };
  };
}
