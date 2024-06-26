{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  home-manager.users.waltmck = {
    xdg.userDirs.enable = true;

    xdg.desktopEntries = {
      "org.gnome.Settings" = {
        name = "Settings";
        comment = "Gnome Control Center";
        icon = "org.gnome.Settings";
        exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
        categories = ["X-Preferences"];
        terminal = false;
      };

      "lf" = {
        name = "lf";
        noDisplay = true;
      };
    };
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    EDITOR = "vim";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  xdg.mime = {
    enable = true;
    defaultApplications = (
      let
        browser = "firefox.desktop";
        pdf = "org.gnome.Evince.desktop";
        video = "io.github.celluloid_player.Celluloid.desktop";
        image = "org.gnome.Loupe.desktop";
        latex = "org.cvfosammmm.Setzer.desktop";

        fileformats = import ./fileformats.nix;
        types = program: type:
          builtins.listToAttrs (builtins.map
            (x: {
              name = x;
              value = program;
            })
            type);
      in
        lib.zipAttrsWith (_: values: values) [
          (types image fileformats.image)
          (types browser fileformats.browser)
          (types video fileformats.audiovideo)
          {
            "application/pdf" = pdf;
            "application/tex" = latex;
          }
        ]
    );
  };
}
