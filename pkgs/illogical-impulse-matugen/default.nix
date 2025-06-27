{ lib, fetchFromGitHub, stdenv }:
stdenv.mkDerivation {
  pname = "illogical-impulse-matugen";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "4f7ed4da53cbe5c3dcc7a4872701147da2250a0f";
    sha256 = "sha256-G+3fX8u31OcdILsY+3oERg8GZql+FOE+6gpdWvEM844=";
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
