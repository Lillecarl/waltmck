# Platform-agnostic configuration
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # -- System Packages --

  environment.systemPackages = with pkgs;
  with gnome; [
    vim
    neovim
    git
    wget
    htop
    pulseaudio
    home-manager
    clang
    openssh
    ncdu
    neofetch
    pciutils
    wl-clipboard
    brightnessctl
    playerctl
    wirelesstools

    libnotify

    nautilus
    geary
    cheese
    baobab
    gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
    gnome-maps
    gnome-software # for flatpak

    # gui
    obsidian
    (mpv.override {scripts = [mpvScripts.mpris];})
    libreoffice
    # spotify <- no aarch64-linux support
    # caprine-bin # <- no aarch64-linux support
    d-spy
    gimp
    transmission_4-gtk
    # discord <- no aarch64-linux support
    icon-library
    dconf-editor
    gnome-secrets

    # tools
    # steam-run # fhs envs <- no aarch64 support
    bat
    eza
    fd
    ripgrep
    fzf
    libnotify
    killall
    zip
    unzip
    glib

    # fun
    glow
    slides
    # yabridge < no aarch64-linux support
    # yabridgectl <- no aarch64-linux support
    # wine-staging <- no aarch64-linux support

    wezterm
  ];
}
