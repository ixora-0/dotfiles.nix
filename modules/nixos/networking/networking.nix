{
  imports = [
    # ./tor.nix
    ./wireguard.nix
  ];

  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  services.resolved = {
    enable = true;
    # dnssec = "true";
    dnssec = "false";
    # domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "opportunistic";
    llmnr = "resolve";
  };
  networking.resolvconf.enable = false;

  networking.firewall.enable = true;
}
