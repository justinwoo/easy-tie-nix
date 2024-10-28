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

  version = "20241028";

  buildInputs = [ pkgs.gmp  ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-tie-nix/macos-latest/${version}.tar.gz";
          sha256 = "sha256-ooDOLHRXSs0Dh+89Yc0cwE5bt5WstEO8NXL/5rHsXDQ=";
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-tie-nix/ubuntu-latest/${version}.tar.gz";
        sha256 = "sha256-+6lauVJdCBOvpZTUDz+GyvbR13GArXS2ALd7W1Qd9S8=";
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
