{ stdenv, file, bat, eza,
  archiveSupport ? true,  atool ? null,
  jupyterSupport ? true,  jupyter ? null,
  jsonSupport ? true,     jq ? null,
  markdownSupport ? true, glow ? null,
  imageSupport ? true,    chafa ? null
}:

assert archiveSupport -> atool != null;
assert jupyterSupport -> jupyter != null;
assert jsonSupport -> jq != null;
assert markdownSupport -> glow != null;
assert imageSupport -> chafa != null;

stdenv.mkDerivation rec {
  name = "lessfilter";
  
  buildInputs = [
    file bat eza
    (if archiveSupport then atool else null)
    (if jupyterSupport then jupyter else null)
    (if jsonSupport then jq else null)
    (if markdownSupport then glow else null)
    (if imageSupport then chafa else null)
  ];
  
  src = fetchurl {
    url = "mirror://sourceforge/mutt/${name}.tar.gz";
    sha256 = "0dzx4qk50pjfsb6cs5jahng96a52k12f7pm0sc78iqdrawg71w1s";
  };

  configureFlags = [
  ];

  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny ];
  };
}
