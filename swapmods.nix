with import <nixpkgs> {};

stdenv.mkDerivation rec {
  pname = "swapmods";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "minego";
    repo = "swapmods";
    rev = "0af1f2feac93b9d29d2addc7596167a4ab92e561"; # Feb 10, 2022
    sha256 = "sha256-yhAjoqweKjNuq87wjFZWhJv2oMVDBrcs0hZ3n0J369E=";
  };

  installPhase = ''
  	mkdir -p $out/bin
	cp swapmods $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/minego/swapmods";
    description = "Swap alt and super";
    license = licenses.asl20; # Apache-2.0
    platforms = platforms.linux;
  };
}
