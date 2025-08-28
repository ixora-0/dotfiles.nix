{
  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "ssh" "secrets" "pkcs11" ];
  home.sessionVariables = {
    SSH_AUTH_SOCK="/run/user/$(id -u)/keyring/ssh";
  };
}
