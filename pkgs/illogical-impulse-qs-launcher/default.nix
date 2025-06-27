{
  lib,
  stdenv,
  makeWrapper,

  brightnessctl,
  cava,
  gammastep,
  kdePackages,
  libqalculate,
  quickshell,
  translate-shell,
}:

stdenv.mkDerivation {
  pname = "illogical-impulse-qs-launcher";
  version = "latest";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 illogical-impulse-qs-launcher $out/bin/illogical-impulse-qs-launcher
  '';

  fixupPhase = ''
    wrapProgram $out/bin/illogical-impulse-qs-launcher \
      --prefix PATH : ${lib.makeBinPath [ 
        # ollama
        quickshell
        brightnessctl
        cava
        gammastep  # NOTE: might change to hypr[shade|sunset]
        libqalculate
        translate-shell
      ]} \
      --prefix QML2_IMPORT_PATH : ${lib.makeSearchPath ":" [
        "${kdePackages.qt5compat}/lib/qt-6/qml"
        "${kdePackages.syntax-highlighting}/lib/qt-6/qml"
      ]}
  '';

  
  # NOTE HACK: replacing kde apps manually in config for now
  # partly because tough to get them working
  # in ~/.config/illogical-impulse/config.json, from
  # "apps": {
  #   "bluetooth": "kcmshell6 kcm_bluetooth",
  #   "network": "plasmawindowed org.kde.plasma.networkmanagement",
  #   "networkEthernet": "kcmshell6 kcm_networkmanagement",
  #   "taskManager": "plasma-systemmonitor --page-name Processes",
  #   "terminal": "kitty -1"
  # },
  # to
  # "apps": {
  #   "bluetooth": "ghostty -e bluetuith",
  #   "network": "ghostty -e nmtui",
  #   "networkEthernet": "ghostty -e nmtui",
  #   "taskManager": "ghostty -e btop",
  #   "terminal": "ghostty"
  # },

  meta = {
    description = "Illogical Impulse Quickshell Launcher";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
    mainProgram = "illogical-impulse-qs";
  };
}
