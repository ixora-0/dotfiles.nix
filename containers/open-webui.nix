{
  image = "ghcr.io/open-webui/open-webui:main";

  environment = {
    "PORT" = "3001";
    "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
    "AUDIO_TTS_ENGINE" = "openai";
    "AUDIO_TTS_OPENAI_API_BASE_URL" = "http://localhost:3003/v1";
    "AUDIO_TTS_OPENAI_API_KEY" = "sk-111111111";
  };

  volumes = [
    "/home/ixora/intaa/open-webui/data:/app/backend/data"
  ];

  ports = ["3001:3001"];

  extraOptions = [
    "--name=open-webui"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
