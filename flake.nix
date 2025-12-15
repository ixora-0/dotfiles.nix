{
  description = "Home Manager configuration of ixora";

  inputs = {
    # NOTE: adding unused flakes still take up extra space
    # stable flakes
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager-stable.url = "github:nix-community/home-manager/release-25.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    # unstable flakes
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.url = "github:numtide/flake-utils";
    # flake-utils.inputs.systems.follows = "systems";

    # nur
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-stable";

    # other flakes
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-stable";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    sops-nix.url = "github:Mic92/sops-nix/e9b5eef9b51cdf966c76143e13a9476725b2f760";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixcord.url = "github:kaylorben/nixcord";
    iosevka-iris.url = "github:ixora-0/iosevka-iris";

    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # helix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, ... }@inputs : let
    inherit (import ./builders.nix inputs) makeNixOSConfig makeHomeConfig makeZero2W;
  in {
    nixosConfigurations = {
      nerine = makeNixOSConfig {
        stability = "stable";
        osArchitecture = "x86_64-linux";
        hostname = "nerine";
        usernames = ["ixora"];
      };
      wisteria = makeNixOSConfig {
        stability = "stable";
        osArchitecture = "x86_64-linux";
        hostname = "wisteria";
        usernames = ["ixora"];
      };
      dierama = makeNixOSConfig {
        stability = "stable";
        osArchitecture = "x86_64-linux";
        hostname = "dierama";
        usernames = ["ixora"];
      };
      ren = makeZero2W {
        stability = "stable";
        hostname = "ren";
        usernames = ["ixora"];
      };
    };
    # build using nix build .#images.ren
    images.ren = self.nixosConfigurations.ren.config.system.build.sdImage;

    homeConfigurations = {
      "ixora@azalea" = makeHomeConfig {
        stability = "unstable";
        osArchitecture = "x86_64-linux";
        hostname = "azalea";
        username = "ixora";
      };
      "ixora@nerine" = makeHomeConfig {
        stability = "stable";
        osArchitecture = "x86_64-linux";
        hostname = "nerine";
        username = "ixora";
      };
      "ixora@dierama" = makeHomeConfig {
        stability = "stable";
        osArchitecture = "x86_64-linux";
        hostname = "dierama";
        username = "ixora";
      };
      "ixora@ren" = makeHomeConfig {
        stability = "stable";
        osArchitecture = "aarch64-linux";
        hostname = "ren";
        username = "ixora";
      };
    };

    deploy = {
      user = "root";
      nodes = {
        ren = {
          sshUser = "root";
          hostname = "ren";
          profiles.system.user = "root";
          profiles.system.path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                                   self.nixosConfigurations.ren;
        };
      };
    };
    checks = builtins.mapAttrs
              (system: deployLib: deployLib.deployChecks self.deploy)
              inputs.deploy-rs.lib;
  };
}
