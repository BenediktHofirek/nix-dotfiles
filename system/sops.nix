{
  inputs,
  pkgs,
  config,
  username,
  ...
}:

let
  home = config.users.users."${username}".home;
  keyFile = "${home}/.config/sops/age/keys.txt";
in
{

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age = {
      keyFile = keyFile;
      generateKey = false;
      sshKeyPaths = [ ];
    };

    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      ssh_key = {
        owner = username;
        mode = "0400";
        path = "${home}/.ssh/id_rsa";
      };

      wifi_password = {
        owner = username;
        mode = "0400";
      };

      github_oauth_token = {
        owner = username;
        mode = "0400";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${home}/.ssh 0700 ${username} users -"
  ];

  # for initial setup of key
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = keyFile;
  };
}
