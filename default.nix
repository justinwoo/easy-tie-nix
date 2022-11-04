{ pkgs ? import <nixpkgs> { } }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  patchelf = libPath:
    if pkgs.stdenv.isDarwin
    then ""
    else ''
      chmod u+w $TIE
      patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $TIE
      chmod u-w $TIE
    '';
in
pkgs.stdenv.mkDerivation rec {
  pname = "tie";

  version = "20221104";

  buildInputs = [ pkgs.gmp  ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "https://github.com/scarf-sh/tie/releases/download/20221104/macos-latest.tar.gz";
          sha256 = "bvCJwgq5wRQNNqgGt06FwT8Cs5X+dE6IYQS8FJvjloU=";
        }
    else
      pkgs.fetchzip {
        url = "https://github.com/scarf-sh/tie/releases/download/20221104/ubuntu-latest.tar.gz";
        sha256 = "CxPNW0Zj0F2vtic5B3w+IbbQVQbI+uyWgzzcFe/OJZo=";
      };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    TIE=$out/bin/tie

    install -D -m555 -T tie $TIE
    ${patchelf libPath}

    mkdir -p $out/etc/bash_completion.d/
    $TIE --bash-completion-script $TIE > $out/etc/bash_completion.d/tie-completion.bash
  '';
}
