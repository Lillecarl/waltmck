{
  pkgs,
  inputs,
  config,
  hostname,
  headless,
  ...
}: {
  # Imports and state version
  system.stateVersion = "24.05";
  imports = [
    "${inputs.home-manager}/nixos"
    "${inputs.impermanence}/nixos.nix"
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # camera
  programs.droidcam.enable = true;

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    #podman.enable = true;
    #docker.enable = true;
    #libvirtd.enable = true;
  };

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
    printing.enable = true;
    # flatpak.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=suspend
  '';

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # If conflicting config files exist, move them to a backup ending with `.hm-bak`.
  home-manager.backupFileExtension = "hm-bak";

  home-manager.users.waltmck = {
    # Imports and stateVersion
    home.stateVersion = "23.11";

    programs.home-manager.enable = true;

    news.display = "show";

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  programs.nix-index-database.comma.enable = true;

  programs.command-not-found.enable = false;

  # -- Persistence --
  environment.persistence."/nix/state" = {
    hideMounts = true;

    files = [
      "/etc/machine-id"
    ];

    directories = [
      "/var/lib/systemd" # For systemd timers, etc. See https://github.com/nbraud/nixpkgs/blob/735481ef6b8be1ef884a6c4b0a4b80264216a379/nixos/doc/manual/administration/systemd-state.section.md
      "/var/lib/nixos" # See https://github.com/nix-community/impermanence/issues/178
    ];

    users.waltmck = {
      directories = [
        ".cache/nix" # Nix evaluation cache
      ];
    };
  };

  systemd = {
    # By default, the limit on the number of open files is too low
    # to allow building from source. This should fix it for the future. See
    # https://discourse.nixos.org/t/unable-to-fix-too-many-open-files-error/27094/7
    extraConfig = "DefaultLimitNOFILE=2048";

    enableCgroupAccounting = true;
  };

  environment.sessionVariables = rec {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  users.mutableUsers = false;

  users.users = {
    root.initialHashedPassword = "$6$EkkeNxXqJ8H12NTS$cgxh3gdWgQTPhZrojyO1TOGdTUH8qWm/184uLBIjTkYpfgJEOQlRXxQuoGgXvskcYAjRS1WcpO04VzzBo4WNw/";

    waltmck = {
      uid = 1000;

      initialHashedPassword = "$6$EkkeNxXqJ8H12NTS$cgxh3gdWgQTPhZrojyO1TOGdTUH8qWm/184uLBIjTkYpfgJEOQlRXxQuoGgXvskcYAjRS1WcpO04VzzBo4WNw/";
      isNormalUser = true;
      extraGroups = ["users" "wheel" "sudo" "networkmanager"];

      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhzYxT+Dociep+0p5a2xr9T8UDJYCa9wbYRNux4LN2 walt@waltmckelvie.com"];

      linger = true; # Systemd user units start at boot rather than login
    };
  };

  environment.systemPackages = let
    os =
      pkgs.writeShellScriptBin
      "os"
      ''
        case $1 in
          "boot")
            sudo nixos-rebuild boot --flake /etc/nixos#${hostname} --impure || exit 1
            ;;
          "switch")
            sudo nixos-rebuild switch --flake /etc/nixos#${hostname} --impure || exit 1
            hyprctl reload; systemctl restart --user ags
            ;;
          "edit")
            ${
          if headless
          then "${pkgs.neovim}/bin/neovim"
          else "${pkgs.neovide}/bin/neovide"
        } /etc/nixos
            ;;
          "gc")
            sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +50 || exit 1
            nix-collect-garbage
            ;;
          "upgrade")
            nix flake upgrade /etx/nixos || exit 1
            ;;
          *)
            echo "Arguments: boot, switch, edit, gc"
            exit 1
            ;;
        esac
      '';
  in [
    os
  ];

  time.timeZone = "America/New_York";
}
