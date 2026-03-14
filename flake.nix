{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-vscode-extensions }:
  let
    mkDarwinSystem = hostname:
      let cfg = import ./hosts/${hostname}/user.config;
      in nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self cfg; };
        modules = [
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = true;
              backupFileExtension = "backup";
              users.${cfg.name} = import ./hosts/common/home.nix;
            };
          }
        ];
      };

    # mkNixosSystem = hostname:
    #   let cfg = import ./hosts/${hostname}/user.config;
    #   in nixpkgs.lib.nixosSystem {
    #     specialArgs = { inherit self cfg; };
    #     modules = [
    #       ./hosts/${hostname}/configuration.nix
    #       home-manager.nixosModules.home-manager
    #       {
    #         home-manager = {
    #           useGlobalPkgs = true;
    #           useUserPackages = true;
    #           users.${cfg.name} = import ./hosts/common/home.nix;
    #         };
    #       }
    #     ];
    #   };
  in
  {
    darwinConfigurations = {
      "DT-FK9XW5PWMN" = mkDarwinSystem "DT-FK9XW5PWMN";
    };

    # nixosConfigurations = {
    #   "linux-hostname" = mkNixosSystem "linux-hostname";
    # };
  };
}
