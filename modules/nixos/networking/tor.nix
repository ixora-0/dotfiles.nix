{
  services.tor.enable = true;
  services.tor.client.enable = true;
  services.privoxy.enable = true;
  services.privoxy.enableTor = true;
  services.privoxy.settings.listen-address = "127.0.0.1:8118";
}
