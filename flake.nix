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

    # flake-utils.url = "github:numtide/flake-utils";
    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # helix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, ... }@inputs: let
    matchStability = stability: stableOption: unstableOption: 
      if stability == "stable" then
        stableOption
      else if stability == "unstable" then
        unstableOption
      else
        builtins.abort "Invalid stability: ${stability}"
      ;
    selectNixpkgs = stability: matchStability stability inputs.nixpkgs-stable inputs.nixpkgs-unstable; 
    selectHomeManager = stability: matchStability stability inputs.hone-manager-stable inputs.home-manager-unstable;

    pkgs-stable = (let
      nixpkgs = selectNixpkgs "stable";
    in
      inputs.flake-utils.lib.eachDefaultSystem (system: { 
        p = import nixpkgs {
          overlays = [inputs.nur.overlay];
          inherit system;
        }; 
      })
    ).p;
    pkgs-unstable = (let
      nixpkgs = selectNixpkgs "unstable";
    in
      inputs.flake-utils.lib.eachDefaultSystem (system: { 
        p = import nixpkgs {
          overlays = [inputs.nur.overlay];
          inherit system;
        }; 
      })
    ).p;
    selectPkgs = stability: matchStability stability pkgs-stable pkgs-unstable;

    makeCommonHomeModule = username: { pkgs, inputs, ... }: {
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.11"; # Please read the comment before changing.

      nixpkgs.overlays = [inputs.nur.overlay];

      home.username = username;
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then
          if (username == "root") then "/var/root" else "/Users/${username}"
        else
          if (username == "root") then "/root" else "/home/${username}"
        ;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };

    makeHomeConfig = stability: osArchitecture: username: homeModule: let
      pkgs = (selectPkgs stability).${osArchitecture};
      home-manager = selectHomeManager stability;
    in 
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (makeCommonHomeModule username)
          homeModule
        ];
        extraSpecialArgs = { inherit inputs; };
      };

    makeNixOSConfig = stability: osArchitecture: username: configModule: homeModule: let
      nixpkgs = selectNixpkgs stability;
      home-manager = selectHomeManager stability;
    in
      nixpkgs.lib.nixosSystem {
        system = osArchitecture;
        modules = [
          # inputs.nur.nixosModules.nur
          home-manager.nixosModules.home-manager 
          {
            # nixpkgs.overlays = [inputs.nur.overlay];
            users.users."${username}".packages = [home-manager];
            home-manager.users."${username}".imports = [
              (makeCommonHomeModule username)
              homeModule
            ];
            home-manager.extraSpecialArgs = { inherit inputs; };
            # By default, Home Manager uses a private pkgs instance that is configured 
            # via the home-manager.users..nixpkgs options. 
            # To instead use the global pkgs that is configured via the system level nixpkgs options, set
            # home-manager.useGlobalPkgs = true; 
          }
          configModule
        ];
        specialArgs = { inherit inputs; };
      };
  in {
    nixosConfigurations = {
      nerine = makeNixOSConfig "unstable" 
                               "x86_64-linux"
                               "ixora" 
                               ./hosts/nerine/configuration.nix 
                               ./hosts/nerine/home.nix;

      # nerine = inputs.nixpkgs-unstable.lib.nixosSystem {
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./hosts/nerine/configuration.nix
      #     inputs.home-manager-unstable.nixosModules.home-manager 
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.users.ixora = import ./hosts/nerine/home.nix;
      #     }
      #   ];
      # };
    };

    homeConfigurations = {
      "ixora@azalea" = makeHomeConfig "unstable"
                                      "x86_64-linux"
                                      "ixora"
                                      ./hosts/azalea/home.nix;
      "ixora@nerine" = makeHomeConfig "unstable"
                                      "x86_64-linux"
                                      "ixora"
                                      ./hosts/nerine/home.nix;
    };
  };
}
