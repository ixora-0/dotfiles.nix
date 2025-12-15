{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  makeWrapper,

  bc,
  glib,
  gsettings-desktop-schemas,
  gtk4,
  jq,
  kdePackages,
  matugen,
  python3,
  python313Packages,
  xdg-user-dirs,
}: let
  idle_inhib_env = (python3.withPackages (p: with p; [
    pywayland
    setproctitle
  ]));
  emojis = callPackage ../emojis.nix {};
in stdenv.mkDerivation {
  pname = "illogical-impulse-qs";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "5ee46cfc30f6b4a690bfada77d40b09cd1517c96";
    sha256 = "sha256-PrCsUvgDJqmfflcSVOMZviGTYocejvYHw45JEbixCm4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out
    cp -r .config/quickshell/* $out/
  '';

  fixupPhase = ''
    # fix perm issues
    sed -i '26a\
    os.chmod(config_file, 0o644)  # change perm
' "$out/scripts/kvantum/changeAdwColors.py"
    sed -i '36a\
  chmod 644 "$STATE_DIR"/user/generated/terminal/sequences.txt
' "$out/scripts/colors/applycolor.sh"

    # create restore wallpaper script folder
    sed -i '118a\
    mkdir -p "$RESTORE_SCRIPT_DIR"
' "$out/scripts/colors/switchwall.sh"
    sed -i '136a\
    mkdir -p "$RESTORE_SCRIPT_DIR"
' "$out/scripts/colors/switchwall.sh"

    # disable applying color to terminal for now
    sed -i '61s/^/#/' $out/scripts/colors/applycolor.sh

    # comment activating python venv
    sed -i '247s/^    /    #/' "$out/scripts/colors/switchwall.sh" 
    sed -i '251s/^    /    #/' "$out/scripts/colors/switchwall.sh" 

    # replace python venv
    sed -i '1s|.*|#!${idle_inhib_env.interpreter}|' "$out/scripts/wayland-idle-inhibitor.py"

    # supply emojis
    sed -i '16s|''${Directories.config}/hypr/hyprland/scripts/fuzzel-emoji.sh|${emojis}|' "$out/services/Emojis.qml"

    # wrap all scripts to use the correct environment
    # HACK: should use gappsWrapperArgs/qtWrapperArgs but brain too small
    for prog in $(find $out -type f -name "*.sh" -executable); do
      wrapProgram $prog \
        --prefix PATH : ${lib.makeBinPath [
          bc
          glib
          jq
          libsForQt5.kdialog
          libsForQt5.plasma-workspace
          matugen
          python313Packages.kde-material-you-colors
          xdg-user-dirs

          (python3.withPackages (p: with p; [
            pillow
            materialyoucolor
            kde-material-you-colors
            numpy
            opencv4
          ]))
        ]} \
        --prefix XDG_DATA_DIRS : ${lib.makeSearchPath ":" [
          "${glib.getSchemaPath gsettings-desktop-schemas}/../.."
          "${glib.getSchemaPath gtk4}/../.."
        ]}
    done
  '';

  meta = {
    description = "Illogical Impulse Quickshell";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
