{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-kvantum";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "5ee46cfc30f6b4a690bfada77d40b09cd1517c96";
    sha256 = "sha256-PrCsUvgDJqmfflcSVOMZviGTYocejvYHw45JEbixCm4=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r .config/Kvantum/* $out/

    runHook postInstall
  '';

  postInstall = ''
    mv $out/MaterialAdw/MaterialAdw.svg $out/MaterialAdw/MaterialAdw.svg.sample
    mv $out/MaterialAdw/MaterialAdw.kvconfig $out/MaterialAdw/MaterialAdw.kvconfig.sample
  '';

  meta = {
    description = "Kvantum theme written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
