{config, ... }: {
  hardware.nvidia = {
    modesetting.enable = true;  # required

    # can cause sleep/suspend to fail
    # enable if graphical corruption issues or application after waking
    powerManagement.enable = true;

    # (experimental) turn off gpu when not in use
    powerManagement.finegrained = false;

    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:6:0:0";
      amdgpuBusId = "PCI:1:0:0";
    };

    # only from driver 515.43.04+
    # currently alpha-quality/buggy, false is currently the recommened setting
    open = false;

    # enable the nvidia settings menu,
    # accessible via `nvidia-settings`
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # load nvidia driver for xorg and wayland
  services.xserver.videoDrivers = ["nvidia"]; 

}
