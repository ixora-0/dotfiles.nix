{
  image = "ghcr.io/matatonic/openedai-speech";

  environment = {
    "TTS_HOME" = "/home/ixora/intaa/openedai-speech/voices";
    "HF_HOME" = "/home/ixora/intaa/openedai-speech/voices";
  };

  volumes = [
    "/home/ixora/intaa/openedai-speech/voices:/app/voices"
    "/home/ixora/intaa/openedai-speech/config:/app/config"
  ];

  ports = ["8087:8000"];

  extraOptions = [
    "--name=openedai-speech"
    "--gpus=all"
  ];
}
