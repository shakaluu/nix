{ config, pkgs, ... }:

let
  nixUpdateCmd = if pkgs.stdenv.isDarwin
    then "sudo darwin-rebuild switch --flake ~/.config/"
    else "sudo nixos-rebuild switch --flake ~/.config/";

  zshCustom = pkgs.stdenvNoCC.mkDerivation {
    name = "zsh-custom";
    src = ./app-themes/zsh-theme;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/themes
      cp $src $out/themes/Berni.zsh-theme
    '';
  };
in
{
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";

    sessionPath = [
      "/opt/homebrew/bin"
      "~/.rd/bin"
    ];

    packages = with pkgs; [
      git-cliff
      gh
      oh-my-zsh
      nixfmt
      pre-commit
      kind
      skaffold
      kubectl
      yq-go
      jq
    ];
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.stdenvNoCC.mkDerivation {
        pname = "vscode";
        version = "1.0.0";
        buildCommand = ''
          mkdir -p $out/bin
          printf '#!/bin/sh\nexec /opt/homebrew/bin/code "$@"\n' > $out/bin/code
          chmod +x $out/bin/code
        '';
      };
      mutableExtensionsDir = true;
      profiles.default = {
        userSettings = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          "workbench.colorTheme" = "One Dark Pro Monokai Darker";
          "git.openRepositoryInParentFolders" = "always";
          "security.workspace.trust.untrustedFiles" = "open";
          "chat.viewSessions.orientation" = "stacked";
          "terminal.external.osxExec" = "Ghostty.app";
        };
        extensions = with pkgs.vscode-marketplace; [
          eserozvataf.one-dark-pro-monokai-darker
          jnoortheen.nix-ide
          esbenp.prettier-vscode
          shd101wyy.markdown-preview-enhanced
          antfu.slidev
          github.copilot-chat
        ];
      };
    };
    zsh = {
      enable = true;
      shellAliases = {
        nix-update = nixUpdateCmd;
      };
      initContent = ''
        KUBE_PS1_PREFIX=""
        KUBE_PS1_SUFFIX=""
        KUBE_PS1_SEPARATOR=""
        KUBE_PS1_SYMBOL_COLOR=null
        KUBE_PS1_CTX_COLOR=null
        KUBE_PS1_SYMBOL_PADDING=true        
      '';
      oh-my-zsh = {
        enable = true;
        custom = "${zshCustom}";
        theme = "Berni";
        plugins = [ "kube-ps1" ];
      };
    };
    git = {
      enable = true;
      settings = {
        alias = import ./git-aliases.nix;
        user = {
          name = "Bernhard Bucher";
          email = "bernhard.bucher@dynatrace.com";
        };
        core = {
          sshCommand = "ssh -i ~/.ssh/dynatrace-id_ed25519";
          editor = "vim";
        };
        init = {
          defaultBranch = "main";
        };
      };
      # Picked it up somewhere, need to verify
      #extraConfig = {
      #  pull.rebase = true;
      #  rebase.autostash = true;
      #};
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile = {
    "ghostty/themes/Berni".source = ./app-themes/ghostty-theme;
    "ghostty/config".text = ''
      theme = Abernathy
    '';
  };
}
