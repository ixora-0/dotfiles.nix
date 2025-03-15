{ config, ... }: {
  # additional configs to compose.nix (compose2nix can't do it all)

  # cloudflared
  sops.secrets.cloudflared_tunnel_token = {
    owner = "ixora";
    sopsFile = ../../secrets/dierama.json;
  };
  sops.templates.cloudflared_env.content = ''
    TUNNEL_TOKEN=${config.sops.placeholder.cloudflared_tunnel_token}
  '';
  virtualisation.oci-containers.containers."dierama-cloudflared" = {
    environmentFiles = [config.sops.templates.cloudflared_env.path];
  };
}
