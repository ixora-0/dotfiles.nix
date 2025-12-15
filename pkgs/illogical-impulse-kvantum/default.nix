{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-kvantum";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "36ff18bfe350b7565497c297cdfa1727e89e52dc";
    sha256 = "sha256-FkIgTaOUFNx8/M+IY1CuI5l51STh0oH39wxPex8t1qE=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/dots/.config/Kvantum/* $out/

    runHook postInstall
  '';

  postInstall = ''
    chmod u+w $out/MaterialAdw
    chmod u+w $out/MaterialAdw/MaterialAdw.svg
    chmod u+w $out/MaterialAdw/MaterialAdw.kvconfig
    mv $out/MaterialAdw/MaterialAdw.svg $out/MaterialAdw/MaterialAdw.svg.sample
    mv $out/MaterialAdw/MaterialAdw.kvconfig $out/MaterialAdw/MaterialAdw.kvconfig.sample
  '';

  meta = {
    description = "Kvantum theme written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
