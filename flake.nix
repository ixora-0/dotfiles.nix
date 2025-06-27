{
  description = "Home Manager configuration of ixora";

  inputs = {
    # NOTE: adding unused flakes still take up extra space
    # stable flakes
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-stable.url = "github:nix-community/home-manager/release-25.05";
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

    quickshell.url = "github:quickshell-mirror/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs-stable";

    # other flakes
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    sops-nix.url = "github:Mic92/sops-nix/e9b5eef9b51cdf966c76143e13a9476725b2f760";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixcord.url = "github:kaylorben/nixcord";

    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # helix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs: let
    inherit (import ./builders.nix inputs) makeNixOSConfig makeHomeConfig;
  in {
    nixosConfigurations = {
      nerine = makeNixOSConfig "stable" 
                               "x86_64-linux"
                               "nerine"
                               ["ixora"];
      wisteria = makeNixOSConfig "stable"
                                 "x86_64-linux"
                                 "wisteria"
                                 ["ixora"];
      dierama = makeNixOSConfig "stable"
                                "x86_64-linux"
                                "dierama"
                                ["ixora"];
    };

    homeConfigurations = {
      "ixora@azalea" = makeHomeConfig "unstable"
                                      "x86_64-linux"
                                      "azalea"
                                      "ixora";
      "ixora@nerine" = makeHomeConfig "stable"
                                      "x86_64-linux"
                                      "nerine"
                                      "ixora";
      "ixora@dierama" = makeHomeConfig "stable"
                                       "x86_64-linux"
                                       "dierama"
                                       "ixora";
    };
  };
}
