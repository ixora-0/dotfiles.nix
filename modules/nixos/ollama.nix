{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    listenAddress = "0.0.0.0";
    # models = ""  # getting an error saying can't set models directory
  };
}
