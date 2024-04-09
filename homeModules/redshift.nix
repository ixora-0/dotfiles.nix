{
  # NOTE: on NixOS, add to systemd.services
  services.redshift = {
    enable = true;

    temperature.day = 6500;
    temperature.night = 3000;
    provider = "manual";
    longitude = -84.0;
    latitude = 41.0;
  };
}
