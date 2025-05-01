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
  virtualisation.oci-containers.containers."dierama-flaresolverr" = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    environment = {
      "TZ" = "America/New_York";
    };
    dependsOn = [
      "dierama-gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:dierama-gluetun"
    ];
  };
  systemd.services."docker-dierama-flaresolverr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
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
  virtualisation.oci-containers.containers."dierama-gluetun" = {
    image = "qmcgaw/gluetun:latest";
    environment = {
      "SERVER_COUNTRIES" = "USA";
      "VPN_SERVICE_PROVIDER" = "mullvad";
      "VPN_TYPE" = "wireguard";
    };
    volumes = [
      "/home/ixora/services/gluetun:/gluetun:rw"
    ];
    labels = {
      "glance.icon" = "/assets/gluetun.svg";
      "glance.name" = "Gluetun";
    };
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-gluetun" = {
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
  virtualisation.oci-containers.containers."dierama-jellyfin" = {
    image = "jellyfin/jellyfin:latest";
    volumes = [
      "/home/ixora/services/jellyfin/cache:/cache:rw"
      "/home/ixora/services/jellyfin/config:/config:rw"
      "/home/ixora/services/servarr/data/media:/data/media:ro"
    ];
    labels = {
      "glance.icon" = "/assets/jellyfin.svg";
      "glance.name" = "Jellyfin";
      "traefik.enable" = "true";
      "traefik.http.routers.jellyfin.rule" = "PathPrefix(`/jellyfin`)";
      "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
    };
    user = "1000:100";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyfin"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-jellyfin" = {
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
  virtualisation.oci-containers.containers."dierama-jellyseerr" = {
    image = "fallenbagel/jellyseerr:latest";
    environment = {
      "TZ" = "America/New_York";
    };
    volumes = [
      "/home/ixora/services/jellyseer/config:/app/config:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    labels = {
      "glance.icon" = "/assets/jellyseerr.svg";
      "glance.name" = "Jellyseerr";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyseerr"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-jellyseerr" = {
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
  virtualisation.oci-containers.containers."dierama-minio-obsidian" = {
    image = "minio/minio:latest";
    volumes = [
      "/home/ixora/hdd/minio/data:/data:rw"
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
  virtualisation.oci-containers.containers."dierama-prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "UMASK" = "002";
    };
    volumes = [
      "/home/ixora/services/prowlarr/config:/config:rw"
    ];
    labels = {
      "glance.icon" = "/assets/prowlarr";
      "glance.name" = "Prowlarr";
    };
    dependsOn = [
      "dierama-gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:dierama-gluetun"
    ];
  };
  systemd.services."docker-dierama-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-dierama-root.target"
    ];
    wantedBy = [
      "docker-compose-dierama-root.target"
    ];
  };
  virtualisation.oci-containers.containers."dierama-qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1000";
      "TORRENTING_PORT" = "6881";
      "TZ" = "America/New_York";
      "WEBUI_PORT" = "8080";
    };
    volumes = [
      "/home/ixora/services/qbittorrent/config:/config:rw"
      "/home/ixora/services/servarr/data/torrents:/data/torrents:rw"
    ];
    labels = {
      "glance.icon" = "/assets/qbittorrent.svg";
      "glance.name" = "qBittorrent";
      "traefik.docker.network" = "traefik-qb-net";
      "traefik.enable" = "true";
      "traefik.http.middlewares.qb-headers.headers.customrequestheaders.Origin" = "";
      "traefik.http.middlewares.qb-headers.headers.customrequestheaders.Referer" = "";
      "traefik.http.middlewares.qb-headers.headers.customrequestheaders.X-Frame-Options" = "SAMEORIGIN";
      "traefik.http.middlewares.qb-redirect.redirectregex.regex" = "^(.*)/qb$";
      "traefik.http.middlewares.qb-redirect.redirectregex.replacement" = "$1/qb/";
      "traefik.http.middlewares.qb-strip.stripprefix.prefixes" = "/qb/";
      "traefik.http.routers.qb.entrypoints" = "web";
      "traefik.http.routers.qb.middlewares" = "qb-strip,qb-redirect,qb-headers";
      "traefik.http.routers.qb.rule" = "PathPrefix(`/qb`)";
      "traefik.http.services.qb.loadbalancer.passhostheader" = "false";
      "traefik.http.services.qb.loadbalancer.server.port" = "8080";
    };
    dependsOn = [
      "dierama-gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:dierama-gluetun"
    ];
  };
  systemd.services."docker-dierama-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-dierama-root.target"
    ];
    wantedBy = [
      "docker-compose-dierama-root.target"
    ];
  };
  virtualisation.oci-containers.containers."dierama-radarr" = {
    image = "lscr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "UMASK" = "002";
    };
    volumes = [
      "/home/ixora/services/radarr/config/:/config:rw"
      "/home/ixora/services/servarr/data:/data:rw"
    ];
    labels = {
      "glance.icon" = "/assets/radarr";
      "glance.name" = "Radarr";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=radarr"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-radarr" = {
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
  virtualisation.oci-containers.containers."dierama-sonarr" = {
    image = "lscr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "UMASK" = "002";
    };
    volumes = [
      "/home/ixora/services/servarr/data:/data:rw"
      "/home/ixora/services/sonarr/config:/config:rw"
    ];
    labels = {
      "glance.icon" = "/assets/sonarr.svg";
      "glance.name" = "Sonarr";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=sonarr"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-sonarr" = {
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
  virtualisation.oci-containers.containers."dierama-tailscale" = {
    image = "tailscale/tailscale:latest";
    environment = {
      "TS_STATE_DIR" = "/var/lib/tailscale";
      "TS_USERSPACE" = "false";
    };
    volumes = [
      "/home/ixora/services/tailscale:/var/lib/tailscale:rw"
    ];
    ports = [
      "80:80/tcp"
      "8080:8080/tcp"
    ];
    labels = {
      "glance.icon" = "/assets/tailscale.svg";
      "glance.name" = "Tailscale";
    };
    log-driver = "journald";
    extraOptions = [
      "--cap-add=net_admin"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--hostname=dierama"
      "--network-alias=tailscale"
      "--network=dierama_default"
    ];
  };
  systemd.services."docker-dierama-tailscale" = {
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
  virtualisation.oci-containers.containers."dierama-traefik-tailscale" = {
    image = "traefik:latest";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    cmd = [ "--log.level=DEBUG" "--api.insecure=true" "--providers.docker=true" "--providers.docker.exposedbydefault=false" "--entryPoints.web.address=:80" ];
    labels = {
      "glance.icon" = "/assets/traefik.svg";
      "glance.name" = "Traefik tailscale";
    };
    dependsOn = [
      "dierama-tailscale"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:dierama-tailscale"
    ];
  };
  systemd.services."docker-dierama-traefik-tailscale" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
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
