{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      open-webui = import ../../containers/open-webui.nix;
    };
  };
}
