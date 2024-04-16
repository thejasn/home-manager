{ config, pkgs, ... }:

let mountdir = "${config.home.homeDirectory}/Drive/work"; in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thn";
  home.homeDirectory = "/home/thn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
 
    # essentials
    pkgs.vim
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.htop
    pkgs.tmux
    pkgs.zsh
    pkgs.iproute2
    pkgs.flameshot
    pkgs.gnumake

    # comms
    # pkgs.discord
    pkgs.brave

    # cloud
    pkgs.kubectl
    pkgs.awscli2
    pkgs.kubernetes-helm
    pkgs.podman
 
    # dev
    pkgs.wezterm
    pkgs.lunarvim
    pkgs.go
    pkgs.lazygit
    pkgs.neovim
    pkgs.ripgrep
    pkgs.fd
    pkgs.meld

    # window manager
    pkgs.brightnessctl
    pkgs.networkmanager_dmenu
    pkgs.xfce.xfce4-clipman-plugin
    pkgs.i3status-rust
    pkgs.font-awesome
    pkgs.pcmanfm

    # work
    pkgs.rclone
    pkgs.fuse3

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/i3/config".source = dotfiles/i3/i3config;
    ".config/i3/i3status-rust.toml".source = dotfiles/i3/i3status-rust.toml;
    ".config/tmux/tmux.conf".source = dotfiles/tmux/tmux.conf;
    ".config/lvim".source = dotfiles/lvim;
    ".config/alacritty".source = dotfiles/alacritty;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  # systemd.user = {
  #   services.onedrive_mount = {
  #     Unit = {
  #         Description = "mount googledrive dirs";
  #     };
  #     Install.WantedBy = [ "multi-user.target" ];
  #     Service = {
  #         ExecStartPre = "/usr/bin/mkdir -p ${mountdir}";
  #         ExecStart = ''
  #             ${pkgs.rclone}/bin/rclone mount work.googledrive: ${mountdir} \
  #                 --dir-cache-time 48h \
  #                 --vfs-cache-max-age 48h \
  #                 --vfs-read-chunk-size 10M \
  #                 --vfs-read-chunk-size-limit 512M \
  #                 --buffer-size 512M
  #         '';
  #         ExecStop = "${pkgs.fuse}/bin/fusermount -u ${mountdir}";
  #         Type = "notify";
  #         Restart = "always";
  #         RestartSec = "10s";
  #         Environment = [ "PATH=${pkgs.fuse}/bin:$PATH" ];
  #     };
  #   };
  # };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thn/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "lvim";
  };

  home.sessionPath = [ "$HOME/go/bin" "/usr/sbin" ]; 

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "thejasn";
    userEmail = "thejasn.416@gmail.com";

    extraConfig = {
      # replace https with ssh
      url = {
        "ssh://git@github.com/thejasn" = {
          insteadOf = "https://github.com/thejasn";
        };
        "ssh://git@github.com/bychoice-tech" = {
          insteadOf = "https://github.com/bychoice-tech";
        };
      };

      merge = {
        conflictstyle = "diff3";
        tool = "meld";
      };

      mergetool.meld = {
        cmd = "meld \"$LOCAL\" \"$MERGED\" \"$REMOTE\" --output \"MERGED\"";
        # cmd = "meld \"$LOCAL\" \"$MERGED\" \"$REMOTE\" --output \"MERGED\"";
      };
    };
  };

 programs.zsh = {
  enable = true;
  enableCompletion = true;
  syntaxHighlighting = {
    enable = true;
  };
  history.size = 10000;
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "robbyrussell";
  };
 };

  programs.go = {
    goPath = "go";
    goBin = "go/bin";
  };
 
}
