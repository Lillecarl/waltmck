{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      "${inputs.home-manager}/nixos"
      "${inputs.impermanence}/nixos.nix"
    ];

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  environment.persistence."/nix/state".directories = [ "/var/lib/iwd" ];
}
