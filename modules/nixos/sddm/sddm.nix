{ lib, inputs, pkgs, ... }: {
  imports = [inputs.silentSDDM.nixosModules.default];
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds.default = pkgs.fetchurl {
      name = "bg.png";
      url = "https://i.postimg.cc/zG7jmntm/bg.png";
      hash = "sha256-inAljgsDPWxySsSmEETL0rRVlK18l53EC+dAXZquIKA=";
    };
    profileIcons.ixora = pkgs.fetchurl {
      name = "ixora.png";
      url = "https://i.postimg.cc/BvN2y4vF/pfp.png";
      hash = "sha256-+4SwH01Yy6BIiU4oTIA/kxNRxfjK4jy3uMAKETo3FLk=";
    };
    settings = {
      "LoginScreen" = {
        background = "bg.png";
      };
      "LockScreen" = {
        background = "bg.png";
      };
    };
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = lib.mkForce true;
  };
}
