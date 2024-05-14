{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [pkgs.fractal];

  home-manager.users.waltmck.wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.fractal}/bin/fractal --gapplication-service" # To get background notifications
  ];

  environment.persistence."/nix/state".users.waltmck = {
    directories = [".local/share/fractal"];
  };
}
