# Platform-agnostic configuration
{
  config,
  lib,
  pkgs,
  inputs,
  headless,
  ...
}:
assert !headless; {
  imports = [
    ../packages/passwords
    ../packages/firefox
    ../packages/obsidian
    # ../packages/vscode
    ../packages/kitty
    # ../packages/blackbox
    ../packages/music
    ../packages/messaging
    ../packages/newsflash
    ../packages/gaming
    ../packages/alacritty
    ../packages/email
    ../packages/torrent

    ../services/gnome
    ../services/hyprland
    ../services/bluetooth
    ../services/audio
    ../services/internet
  ];

  # -- System Packages --

  environment.systemPackages = with pkgs;
  with gnome; [
    playerctl

    nautilus
    geary
    # cheese
    guvcview
    baobab
    # gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
    gnome-maps
    gnome-photos
    gnome-contacts
    seahorse
    gnome-power-manager
    # gnome-secrets
    gnome-logs # systemd logs
    endeavour # tasks manager
    networkmanagerapplet

    evolution # Necessary to configure FastMail calendar for God knows what reason
    # gnome-software # for flatpak

    # gui
    obsidian
    (mpv.override {scripts = [mpvScripts.mpris];})
    libreoffice
    # spotify <- no aarch64-linux support
    # caprine-bin # <- no aarch64-linux support
    d-spy
    # gimp
    # discord <- no aarch64-linux support
    icon-library
    dconf-editor

    # fun
    glow
    slides
    # yabridge < no aarch64-linux support
    # yabridgectl <- no aarch64-linux support
    # wine-staging <- no aarch64-linux support

    wezterm

    setzer # LaTex
    # texlive.combined.scheme-tetex
    texliveMedium
    tectonic
    texpresso
    # texlivePackages.synctex
    passes # Passes manager

    # File Readers

    papers # PDF reader
    zathura # Another PDF viewer

    celluloid # Video player
    delfin # Jellyfin streaming
    foliate # ebook reader
    loupe # Image viewe

    shortwave # Internate radio
    wike # wikipedia reader
    gnome-podcasts # Podcasts

    zim # Notes app to try

    ## COMMUNICATION

    polari # IRC client
    calls # Gnome Calls, a voip client

    g4music

    notify-client #ntfy client

    varia # Download manager, wraps aria2

    slack-term # Slack client

    inputs.zotero-nix.packages.${system}.default

    # cozy # Audiobooks

    dino # XMPP/Jabber client
  ];

  environment.persistence."/nix/state".users.waltmck.directories = [
    "Zotero"
    ".config/delfin"
    "Books"
    "Audiobooks"
    ".local/share/cozy"
    ".cache/cozy"
  ];
}
