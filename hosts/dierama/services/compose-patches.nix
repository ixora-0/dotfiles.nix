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
}
