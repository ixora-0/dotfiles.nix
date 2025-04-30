{ config, ... }: {
  # additional configs to compose.nix (compose2nix can't do it all)

  # -- load secrets -----------------------------------------------------------
  # cloudflared
  sops.secrets.cloudflared_tunnel_token = {
    owner = "ixora";
    sopsFile = ../../../secrets/dierama.json;
  };
  sops.templates.cloudflared_env.content = ''
    TUNNEL_TOKEN=${config.sops.placeholder.cloudflared_tunnel_token}
  '';
  virtualisation.oci-containers.containers."dierama-cloudflared" = {
    environmentFiles = [config.sops.templates.cloudflared_env.path];
  };
  # speedtest-tracker
  sops.secrets.speedtest-tracker_app_key.sopsFile = ../../../secrets/dierama.json;
  sops.secrets.speedtest-tracker_app_url.sopsFile = ../../../secrets/dierama.json;
  sops.templates.speedtest-tracker_env.content = ''
    APP_KEY=${config.sops.placeholder.speedtest-tracker_app_key}
    APP_URL=${config.sops.placeholder.speedtest-tracker_app_url}
    ASSET_URL=${config.sops.placeholder.speedtest-tracker_app_url}
  '';
  virtualisation.oci-containers.containers."dierama-speedtest-tracker" = {
    environmentFiles = [config.sops.templates.speedtest-tracker_env.path];
  };
  # vaultwarden
  sops.secrets.vaultwarden_domain.sopsFile = ../../../secrets/dierama.json;
  sops.secrets.vaultwarden_admin_token.sopsFile = ../../../secrets/dierama.json;
  sops.templates.vaultwarden_env.content = ''
    DOMAIN=${config.sops.placeholder.vaultwarden_domain}
    ADMIN_TOKEN=${config.sops.placeholder.vaultwarden_admin_token}
  '';
  virtualisation.oci-containers.containers."dierama-vaultwarden" = {
    environmentFiles = [config.sops.templates.vaultwarden_env.path];
  };
  # minio-obsidian
  sops.secrets.minio-obsidian_root_user.sopsFile = ../../../secrets/dierama.json;
  sops.secrets.minio-obsidian_root_password.sopsFile = ../../../secrets/dierama.json;
  sops.templates.minio-obsidian_env.content = ''
    MINIO_ROOT_USER=${config.sops.placeholder.minio-obsidian_root_user}
    MINIO_ROOT_PASSWORD=${config.sops.placeholder.minio-obsidian_root_password}
  '';
  virtualisation.oci-containers.containers."dierama-minio-obsidian" = {
    environmentFiles = [config.sops.templates.minio-obsidian_env.path];
  };
  # gluetun
  sops.secrets.gluetun_wireguard_private_key.sopsFile = ../../../secrets/dierama.json;
  sops.secrets.gluetun_wireguard_addresses.sopsFile = ../../../secrets/dierama.json;
  sops.templates.gluetun_env.content = ''
    WIREGUARD_PRIVATE_KEY=${config.sops.placeholder.gluetun_wireguard_private_key}
    WIREGUARD_ADDRESSES=${config.sops.placeholder.gluetun_wireguard_addresses}
  '';
  virtualisation.oci-containers.containers."dierama-gluetun" = {
    environmentFiles = [config.sops.templates.gluetun_env.path];
  };
  # tailscale
  sops.secrets.tailscale_ts_authkey.sopsFile = ../../../secrets/dierama.json;
  sops.templates.tailscale_env.content = ''
    TS_AUTHKEY=${config.sops.placeholder.tailscale_ts_authkey}
  '';
  virtualisation.oci-containers.containers."dierama-tailscale" = {
    environmentFiles = [config.sops.templates.tailscale_env.path];
  };
}
