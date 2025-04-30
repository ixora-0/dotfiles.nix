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
    labels = {
      "glance.icon" = "/assets/cloudflare.svg";
      "glance.name" = "Cloudflared";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=cloudflared"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-cloudflared" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
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
  virtualisation.oci-containers.containers."dierama-glance" = {
    image = "glanceapp/glance";
    volumes = [
      "/home/ixora/services/glance/assets:/app/assets:ro"
      "/home/ixora/services/glance/config:/app/config:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    labels = {
      "glance.name" = "Glance";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=glance"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-glance" = {
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
  virtualisation.oci-containers.containers."dierama-minio-obsidian" = {
    image = "minio/minio:latest";
    volumes = [
      "/home/ixora/services/minio-obsidian/data:/data:rw"
    ];
    cmd = [ "server" "/data" "--console-address" ":9001" ];
    labels = {
      "glance.icon" = "/assets/minio-obsidian.svg";
      "glance.name" = "Obsidian DB";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=minio-obsidian"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-minio-obsidian" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
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
  virtualisation.oci-containers.containers."dierama-open-webui" = {
    image = "ghcr.io/open-webui/open-webui:latest";
    environment = {
      "AIOHTTP_CLIENT_TIMEOUT_OPENAI_MODEL_LIST" = "5";
      "PORT" = "3000";
    };
    volumes = [
      "/home/ixora/services/open-webui/data:/app/backend/data:rw"
    ];
    labels = {
      "glance.icon" = "/assets/open-webui.png";
      "glance.name" = "Open WebUI";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=open-webui"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-open-webui" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
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
  virtualisation.oci-containers.containers."dierama-speedtest-tracker" = {
    image = "lscr.io/linuxserver/speedtest-tracker:latest";
    environment = {
      "DB_CONNECTION" = "sqlite";
      "DISPLAY_TIMEZONE" = "America/New_York";
      "PGID" = "1000";
      "PUID" = "1000";
      "SPEEDTEST_SCHEDULE" = "\"0 */3 * * *\"";
    };
    volumes = [
      "/home/ixora/services/speedtest-tracker:/config:rw"
    ];
    labels = {
      "glance.icon" = "/assets/speedtest-tracker.png";
      "glance.name" = "Speedtest Tracker";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=speedtest-tracker"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-speedtest-tracker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
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
  virtualisation.oci-containers.containers."dierama-vaultwarden" = {
    image = "vaultwarden/server:latest";
    environment = {
      "SIGNUPS_ALLOWED" = "false";
    };
    volumes = [
      "/home/ixora/services/vaultwarden/vw-data:/data:rw"
    ];
    labels = {
      "glance.icon" = "/assets/vaultwarden.svg";
      "glance.name" = "Vaultwarden";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=vaultwarden"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-vaultwarden" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
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
