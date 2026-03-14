{ pkgs, self, cfg, ... }:

{
  users.users.${cfg.name} = cfg;

  system.primaryUser = cfg.name;

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  ids.uids.nixbld = 352;
  ids.gids.nixbld = 352;

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [];
    brews = [
      "vim"
      "neofetch"
      "wget"
      "helm"
      "docker"
      "docker-credential-helper"
    ];
    casks = [
      "capacities"
      "rancher"
      "visual-studio-code"
      "ghostty"
    ];
  };
}
