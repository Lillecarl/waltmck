{...}: {
  imports = [
    ./nginx.nix
    ./headscale.nix
    ./transmission.nix
  ];

  users.groups."data" = {
    gid = 791;
    name = "data";
  };

  users.users."data" = {
    name = "data";
    group = "data";
    isSystemUser = true;
    uid = 791;

    home = "/nix/state/home/data";
    createHome = true;
  };

  # Later: replace this with a mounted volume
  environment.persistence."/nix/state" = {
    directories = [
      {
        directory = "/data";
        user = "data";
        group = "data";
        mode = "777";
      }
    ];
  };

  services.syncthing = {
    user = "data";
    group = "data";

    dataDir = "/data/syncthing";
    configDir = "/nix/state/home/data/.config/syncthing";
  };
}
