{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFile = ../../secrets/secrets.json;
  sops.defaultSopsFormat = "json";
  sops.age.keyFile = "/home/ixora/.config/sops/age/keys.txt";
}
