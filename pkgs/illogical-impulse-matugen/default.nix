{ lib, fetchFromGitHub, stdenv }:
stdenv.mkDerivation {
  pname = "illogical-impulse-matugen";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "5ee46cfc30f6b4a690bfada77d40b09cd1517c96";
    sha256 = "sha256-PrCsUvgDJqmfflcSVOMZviGTYocejvYHw45JEbixCm4=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/.config/matugen/* $out/
  '';

  meta = {
    description = "Matugen config written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
