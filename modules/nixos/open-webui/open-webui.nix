# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }: {
  # TODO: Add option to disable certain containers.

  # == Runtime ================================================================
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  # == Containers =============================================================
  # Ollama
  virtualisation.oci-containers.containers."open-webui-ollama" = {
    image = "ollama/ollama";
    volumes = [
      "/home/ixora/intaa/ollama_models:/root/.ollama/models:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=ollama"
      "--network=open-webui-network"
    ];
  };
  systemd.services."docker-open-webui-ollama" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-open-webui-network.service"
    ];
    requires = [
      "docker-network-open-webui-network.service"
    ];
    partOf = [
      "docker-compose-open-webui-root.target"
    ];
    wantedBy = [
      "docker-compose-open-webui-root.target"
    ];
  };

  # Openedai-speech
  virtualisation.oci-containers.containers."open-webui-openedai-speech" = {
    image = "ghcr.io/matatonic/openedai-speech";
    environment = {
      "HF_HOME" = "/home/ixora/intaa/openedai-speech/voices";
      "TTS_HOME" = "/home/ixora/intaa/openedai-speech/voices";
    };
    volumes = [
      "/home/ixora/intaa/openedai-speech/config:/app/config:rw"
      "/home/ixora/intaa/openedai-speech/voices:/app/voices:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=openedai-speech"
      "--network=open-webui-network"
    ];
  };
  systemd.services."docker-open-webui-openedai-speech" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-open-webui-network.service"
    ];
    requires = [
      "docker-network-open-webui-network.service"
    ];
    partOf = [
      "docker-compose-open-webui-root.target"
    ];
    wantedBy = [
      "docker-compose-open-webui-root.target"
    ];
  };

  # Searxng

  # Secret
  sops.secrets.searxng = { };
  # Setup sops template
  # NOTE: ideally would provide path directly via sops.templates..file,
  # but can't interpolate the placeholder when reading path
  # https://discourse.nixos.org/t/output-path-interpolation-in-file-sources/11961
  sops.templates."searxng-settings.yaml" = {
    owner = "ixora";
    content = builtins.replaceStrings ["ultrasecretkey"] [config.sops.placeholder.searxng]
      (builtins.readFile ./searxng/settings.yml);
  };
  # # Symlinking config to docker volume
  # xdg.configFile = {
  #   # https://www.reddit.com/r/NixOS/comments/1dlk4vg/how_to_make_homemanager_create_symlinks/
  #   "searxng/settings.yml".source = config.lib.file.mkOutOfStoreSymlink osConfig.;
  #   "searxng/uwsgi.ini".source = ../../../../modules/nixos/open-webui/searxng/uwsgi.ini;
  #   "searxng/limiter.toml".source = ../../../../modules/nixos/open-webui/searxng/limiter.toml;
  # };
  virtualisation.oci-containers.containers."open-webui-searxng" = {
    image = "searxng/searxng";
    volumes = [
      "${./searxng/limiter.toml}:/etc/searxng/limiter.toml:ro"
      "${config.sops.templates."searxng-settings.yaml".path}:/etc/searxng/settings.yml:ro"
      "${./searxng/uwsgi.ini}:/etc/searxng/uwsgi.ini:ro"
    ];
    ports = [
      "3001:8080/tcp"
    ];
    user = "1000";  # NOTE: 1000 = ixora
                    # Waiting for rootless docker for home manager.
    log-driver = "journald";
    extraOptions = [
      "--network-alias=searxng"
      "--network=open-webui-network"
    ];
  };
  systemd.services."docker-open-webui-searxng" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-open-webui-network.service"
    ];
    requires = [
      "docker-network-open-webui-network.service"
    ];
    partOf = [
      "docker-compose-open-webui-root.target"
    ];
    wantedBy = [
      "docker-compose-open-webui-root.target"
    ];
  };

  # Open WebUI
  virtualisation.oci-containers.containers."open-webui" = {
    image = "ghcr.io/open-webui/open-webui:latest";
    environment = {
      "PORT" = "3000";
      "OLLAMA_BASE_URL" = "http://ollama:11434";
      "AUDIO_TTS_ENGINE" = "openai";
      "AUDIO_TTS_OPENAI_API_BASE_URL" = "http://openedai-speech:8000/v1";
      "AUDIO_TTS_OPENAI_API_KEY" = "sk-111111111";
    };
    volumes = [
      "/home/ixora/intaa/open-webui/data:/app/backend/data:rw"
    ];
    ports = [
      "3000:3000/tcp"
    ];
    dependsOn = [
      "open-webui-ollama"
      "open-webui-openedai-speech"
      "open-webui-searxng"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=open-webui"
      "--network=open-webui-network"
    ];
  };
  systemd.services."docker-open-webui" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-open-webui-network.service"
    ];
    requires = [
      "docker-network-open-webui-network.service"
    ];
    partOf = [
      "docker-compose-open-webui-root.target"
    ];
    wantedBy = [
      "docker-compose-open-webui-root.target"
    ];
  };

  # == Networks ===============================================================
  systemd.services."docker-network-open-webui-network" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f open-webui-network";
    };
    script = ''
      docker network inspect open-webui-network || docker network create open-webui-network
    '';
    partOf = [ "docker-compose-open-webui-root.target" ];
    wantedBy = [ "docker-compose-open-webui-root.target" ];
  };


  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-open-webui-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
