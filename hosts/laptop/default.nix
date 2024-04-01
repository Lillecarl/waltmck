# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../shared/shared.nix
      ../../hardware/asahi
      ../../hardware/filesystem
      ../../hardware/sound
      ../../packages/_1password
      ../../packages/bash
      ../../packages/git
      ../../packages/iwd
      ../../packages/ssh
      ../../packages/firefox
      ../../packages/obsidian

      ../../packages/iwd
    ];

  # See installation notes for how to find this
  boot.initrd.luks.devices."encrypted".device = "/dev/disk/by-uuid/0caf6fe9-a9e6-4f18-ada4-a9acc1609799";

  # -- Set hostname --
  
  networking.hostName = "walt-laptop";

  system.stateVersion = "24.05"; # Did you read the comment?

}
