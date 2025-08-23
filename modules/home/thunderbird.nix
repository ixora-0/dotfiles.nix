{
  programs.thunderbird.enable = true;
  programs.thunderbird.profiles."torproxy" = {
    isDefault = true;
    settings = {
      "network.proxy.socks" = "127.0.0.1";
      "network.proxy.socks_port" = 8118;
      "network.proxy.type" = 1;
      "network.proxy.socks_remote_dns" = true;
    };
  };
}
