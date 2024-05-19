{
  image = "ghcr.io/open-webui/open-webui:main";

  environment = {
    "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
  };

  volumes = [
    "/home/ixora/open-webui/data:/app/backend/data"
  ];

  ports = ["3000:8080"];

  extraOptions = [
    "--name=open-webui"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
