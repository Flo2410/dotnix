{
  description = "My NixOS configuaration";

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkSystem = modules: nixpkgs.lib.nixosSystem {
        modules = modules ++ [ home-manager.nixosModules.default ];
        specialArgs = { inherit inputs outputs; };
      };

      mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
        inherit modules;
        pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs; };
      };

    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Reusable nixos modules you might want to export
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        fwf = mkSystem [ ./profiles/fwf/configuration.nix ];
        wsl = mkSystem [ ./profiles/wsl/configuration.nix ];
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # homeConfigurations = {
      #   "florian@fwf" = mkHome "x86_64-linux" [ ./profiles/fwf/home.nix ];
      # };

      devShells = forAllSystems (system:
        let
          callPackage = nixpkgs.legacyPackages.${system}.callPackage;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              outputs.overlays.additions
              outputs.overlays.modifications
              outputs.overlays.unstable-packages

              inputs.nix-vscode-extensions.overlays.default
              inputs.rust-overlay.overlays.default
            ];
          };
        in
        {
          nodejs = callPackage ./nix/shells/nodejs.nix { inherit pkgs; };
          rust = callPackage ./nix/shells/rust.nix { inherit pkgs; };
          python = callPackage ./nix/shells/python.nix { inherit pkgs; };
          latex = callPackage ./nix/shells/latex.nix { inherit pkgs; };
          cpp = callPackage ./nix/shells/cpp.nix { inherit pkgs; };
          ros2 = callPackage ./nix/shells/ros2.nix { inherit pkgs; };
        });
    };

  nixConfig = {
    extra-trusted-substituters = [
      "https://ros.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
    ];
  };


  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Fix Remmina to v1.4.30 -> Needed because starting with v1.4.31 the FHWN RDP does not work 
    nixpkgs-remmina.url = "nixpkgs/3c7a68613bc524f028fa1f5396194eb5fdcbf4ac";

    flake-utils.url = github:numtide/flake-utils;

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # https://gitlab.com/doronbehar/nix-matlab
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/gmodena/nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

}
