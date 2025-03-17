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
}
