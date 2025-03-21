inputs: rec {
  matchStability = stability: stableOption: unstableOption:
    if stability == "stable" then
      stableOption
    else if stability == "unstable" then
      unstableOption
    else
      builtins.abort "Invalid stability: ${stability}"
    ;

  selectNixpkgs = stability: matchStability stability inputs.nixpkgs-stable inputs.nixpkgs-unstable;
  selectHomeManager = stability: matchStability stability inputs.home-manager-stable inputs.home-manager-unstable;

  overlays = [inputs.nur.overlays.default];  # common overlays

  makePkgs = stability: osArchitecture: hostname: usernames: let
    nixpkgs = selectNixpkgs stability;
    mergedUnfrees = builtins.foldl' 
      (
        acc: username: let
          unfrees = ./users/${username}/at/${hostname}/unfrees.nix;
        in (
          acc ++ (if builtins.pathExists unfrees then
            import unfrees
          else
            []
          )
        )
      )
      []
      usernames
    ;

    config = let
      helpers = import ./helpers { lib = nixpkgs.lib; };
    in {
      allowUnfreePredicate = helpers.makeUnfreePredicate mergedUnfrees;
    };
  in (
    import nixpkgs {
      system = osArchitecture;
      inherit overlays config;
    }
  );

  makeCommonHomeModule = username: { pkgs, inputs, ... }: {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

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

  makeHomeConfig = stability: osArchitecture: hostname: username: let
    pkgs-stable = makePkgs "stable" osArchitecture hostname [username];
    pkgs-unstable = makePkgs "unstable" osArchitecture hostname [username];
    pkgs = matchStability stability pkgs-stable pkgs-unstable;
    helpers = import ./helpers { lib = pkgs.lib; };
    home-manager = selectHomeManager stability;
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        (makeCommonHomeModule username)
        ./users/${username}/at/${hostname}
      ];
      extraSpecialArgs = { inherit inputs pkgs-stable pkgs-unstable helpers; };
    };

  makeNixOSConfig = stability: osArchitecture: hostname: usernames: let
    nixpkgs = selectNixpkgs stability;
    pkgs-stable = makePkgs "stable" osArchitecture hostname usernames;
    pkgs-unstable = makePkgs "unstable" osArchitecture hostname usernames;
    pkgs = matchStability stability pkgs-stable pkgs-unstable;
    helpers = import ./helpers { lib = pkgs.lib; };
    home-manager = selectHomeManager stability;
    makeUserNixOSModule = username: {
      users.users."${username}".packages = [home-manager];
      home-manager.users."${username}".imports = [
        (makeCommonHomeModule username)
        ./users/${username}/at/${hostname}
      ];
    };
  in
    nixpkgs.lib.nixosSystem {
      system = osArchitecture;
      modules = [
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs = { inherit pkgs; };
          home-manager.extraSpecialArgs = { inherit inputs pkgs-stable pkgs-unstable helpers; };
          networking.hostName = hostname;

          # By default, Home Manager uses a private pkgs instance that is configured
          # via the home-manager.users..nixpkgs options.
          # To instead use the global pkgs that is configured via the system level nixpkgs options, set
          home-manager.useGlobalPkgs = true;
        }
      ] ++ (map makeUserNixOSModule usernames);
      specialArgs = { inherit inputs pkgs-stable pkgs-unstable helpers; };
    };
}
