{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [pkgs.kitty];

  home-manager.users.waltmck = {
    programs.kitty = {
      enable = true;

      settings = {
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        update_check_interval = 0;
        touch_scroll_multiplier = "2.0";
      };

      font = {
        name = "CaskaydiaCove Nerd Font";
        size = 12;
      };

      theme = "Adwaita darker"; # "Mishran"; # "GitHub Dark";

      shellIntegration.enableZshIntegration = true;
    };
  };
}
