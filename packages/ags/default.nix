{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  security.pam.services.ags = {};
  home-manager.users.waltmck = {
    imports = [inputs.ags.homeManagerModules.default inputs.astal.homeManagerModules.default];

    programs.ags.enable = true;

    programs.astal = {
      enable = true;
      extraPackages = with pkgs; [
        libadwaita
      ];
    };

    home.file.".config/ags/" = {
      source = ./config;
      recursive = true;
    };

    home.file.".config/hypr/per-app/ags.conf" = {
      text = ''
        exec-once = sleep 2 && pkill ags; ags 2>&1 | tee -a /tmp/ags.log & disown
      '';
      # ^ script reloads / launches ags, outputs logs to tmp dir
    };

    home.packages = with pkgs; [
      bun
      dart-sass
      fd
      brightnessctl
      swww
      #inputs.matugen.packages.${system}.default
      slurp
      wf-recorder
      wl-clipboard
      wayshot
      swappy
      hyprpicker
      pavucontrol
      networkmanager
      gtk3
    ];

    home.file.".config/ags/colours.css" = {
      text = ''
        @define-color c0 #${config.colorscheme.palette.base00};
        @define-color c1 #${config.colorscheme.palette.base01};
        @define-color c2 #${config.colorscheme.palette.base02};
        @define-color c3 #${config.colorscheme.palette.base03};
        @define-color c4 #${config.colorscheme.palette.base04};
        @define-color c5 #${config.colorscheme.palette.base05};
        @define-color c6 #${config.colorscheme.palette.base06};
        @define-color c7 #${config.colorscheme.palette.base07};
        @define-color c8 #${config.colorscheme.palette.base08};
        @define-color c9 #${config.colorscheme.palette.base09};
        @define-color ca #${config.colorscheme.palette.base0A};
        @define-color cb #${config.colorscheme.palette.base0B};
        @define-color cc #${config.colorscheme.palette.base0C};
        @define-color cd #${config.colorscheme.palette.base0D};
        @define-color ce #${config.colorscheme.palette.base0E};
        @define-color cf #${config.colorscheme.palette.base0F};
      '';
    };
    # ^ define nix-colors palette, each device has this defined in /hosts/foo/default.nix
  };
}
