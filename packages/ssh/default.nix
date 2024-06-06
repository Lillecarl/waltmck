{
  config,
  lib,
  pkgs,
  inputs,
  headless,
  ...
}: {
  home-manager.users.waltmck = {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "walt-server" = {
          hostname = "waltmckelvie.com";
          user = "waltmck";
          forwardAgent = true;
        };
        "walt-cloud" = {
          hostname = "cloud.waltmckelvie.com";
          user = "waltmck";
          forwardAgent = true;
        };
      };

      userKnownHostsFile = "/nix/state/home/waltmck/.ssh/known_hosts";
    };
  };

  # Persist known_hosts
  environment.persistence."/nix/state".users.waltmck = {
    files = [".ssh/known_hosts"];
  };

  environment.persistence."/nix/state".directories =
    if headless
    then [
      "/etc/ssh"
    ]
    else [];

  services.openssh = {
    enable = headless; # Disable ssh server (save battery, increase security) if not headless
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PrintLastLog = false;
    };
  };

  # Open ssh port if headless
  networking.firewall.allowedTCPPorts =
    if headless
    then [22]
    else [];
}
