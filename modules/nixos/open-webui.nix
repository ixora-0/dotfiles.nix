{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      open-webui = import ../../containers/open-webui.nix;
    };
  };
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /home/ixora/open-webui/data -o root -g root
    '';
  };
}
