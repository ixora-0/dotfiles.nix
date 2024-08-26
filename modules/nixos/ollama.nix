{pkgs-unstable, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;
    acceleration = "cuda";
    listenAddress = "0.0.0.0";
    models = "/home/ixora/intaa/ollama_models/";
    sandbox = false;
  };
}
