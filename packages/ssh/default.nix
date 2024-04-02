{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = ["${inputs.home-manager}/nixos"];

  home-manager.users.waltmck = {
    programs.ssh = {
      enable = true;

      extraConfig = lib.mkOrder 1 ''
        Host walt-server
            HostName waltmckelvie.com
            User waltmck
            ForwardAgent yes
      '';
    };
  };
}
