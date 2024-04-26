{
  description = "Home Manager configuration of ixora";

  inputs = {
    # NOTE: adding unused flakes still take up extra space
    # stable flakes
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
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

    # other flakes
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";
    matugen.url = "github:InioX/matugen";

    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # helix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs: let
    inherit (import ./builders.nix inputs) makeNixOSConfig makeHomeConfig;
  in {
    nixosConfigurations = {
      nerine = makeNixOSConfig "unstable" 
                               "x86_64-linux"
                               "nerine"
                               ["ixora"];
    };

    homeConfigurations = {
      "ixora@azalea" = makeHomeConfig "unstable"
                                      "x86_64-linux"
                                      "azalea"
                                      "ixora";
      "ixora@nerine" = makeHomeConfig "unstable"
                                      "x86_64-linux"
                                      "nerine"
                                      "ixora";
    };
  };
}
