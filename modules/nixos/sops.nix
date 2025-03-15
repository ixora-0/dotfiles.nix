{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFormat = "json";
  # TODO: improve design here
  sops.age.keyFile = "/home/ixora/.config/sops/age/keys.txt";
}
