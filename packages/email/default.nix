{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.waltmck = {
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.astroid.enable = true;
    programs.aerc = {
      enable = true;
      extraConfig.general.unsafe-accounts-conf = true;
    };

    programs.neomutt.enable = true;

    programs.notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };

    accounts.email = {
      accounts.fastmail = {
        address = "walt@mckelvie.org";
        imap.host = "imap.fastmail.com";
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        astroid.enable = true;
        aerc.enable = true;
        neomutt.enable = true;

        primary = true;
        realName = "Walter McKelvie";
        signature = {
          text = ''
          '';
          showSignature = "append";
        };
        passwordCommand = "op item get fastmail_walt-laptop --fields password";
        smtp = {
          host = "smtp.fastmail.com";
        };
        userName = "walt@mckelvie.org";
      };
    };
  };
}
