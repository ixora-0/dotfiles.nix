# NOTE: not in use right now
{
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enableNvidia = true;  # HACK: this is deprecated and the above line should be used
                                              # but doesn't work without this
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      openedai-speech = import ../../containers/openedai-speech.nix;
    };
  };
}
