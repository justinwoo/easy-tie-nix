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

  version = "20230228";

  buildInputs = [ pkgs.gmp ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-tie-nix/macos-latest/20230228.tar.gz";
          sha256 = "AOhe2ZS7yxBKlItxxtfNlq6k+q5K1bfr8+/uRlZuiV0=";
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-tie-nix/ubuntu-latest/20230228.tar.gz";
        sha256 = "K5pnNCudvU4ri5bSVTf8H4mwZ2r8k88Ol3P/xfKDN+c=";
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
