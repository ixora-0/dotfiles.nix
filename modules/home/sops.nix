# NOTE: not in use right now
# watch https://github.com/Mic92/sops-nix/issues/423
{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  home.packages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFile = ../../secrets/secrets.json;
  sops.defaultSopsFormat = "json";
  sops.age.keyFile = "/home/ixora/.config/sops/age/keys.txt";
}
