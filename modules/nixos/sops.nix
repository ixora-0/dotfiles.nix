{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFormat = "json";
  # NOTE: path should be available at boot (not mounted probably)
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
}
