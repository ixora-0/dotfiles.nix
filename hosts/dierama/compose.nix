# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."dierama-cloudflared" = {
    image = "cloudflare/cloudflared:latest";
    cmd = [ "tunnel" "--no-autoupdate" "run" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=cloudflared"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-cloudflared" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "docker-network-dierama_default.service"
    ];
    requires = [
      "docker-network-dierama_default.service"
    ];
    partOf = [
      "docker-compose-dierama-root.target"
    ];
    wantedBy = [
      "docker-compose-dierama-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-dierama_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f dierama_default";
    };
    script = ''
      docker network inspect dierama_default || docker network create dierama_default
    '';
    partOf = [ "docker-compose-dierama-root.target" ];
    wantedBy = [ "docker-compose-dierama-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-dierama-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
