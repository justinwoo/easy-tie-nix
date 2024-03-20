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

  version = "20240305";

  buildInputs = [ pkgs.gmp  ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  tie-repo = pkgs.fetchFromGitHub {
    owner= "scarf-sh";
    repo= "tie";
    rev= "efcc04057d1c362e4eb89fe7e713f84a8a229cc6";
    hash= "sha256-9NJ0jFcFUV+4YfwsGzm16ETT+sHG1OkgqgNyD0mpOiY=";
  };

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-tie-nix/macos-latest/20240305.tar.gz";
          sha256 = "fxh+9n3MoQMXumbnChNORFuK2XBvzBlPX9u4HQra/ro=";
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-tie-nix/ubuntu-latest/20240305.tar.gz";
        sha256 = "ExGQq7aDt4pDLcw+eCXbDVBe64jcrXLUmfdo+rHcCkA=";
      };

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    TIE=$out/bin/tie

    install -D -m555 -T tie $TIE
    ${patchelf libPath}

    mkdir -p $out/etc/bash_completion.d/
    $TIE --bash-completion-script $TIE > $out/etc/bash_completion.d/tie-completion.bash

    mkdir -p $out/share
    cp ${tie-repo}/*template* $out/share

    mkdir -p $out/share/test
    cp ${tie-repo}/test/golden -r $out/share/test
  '';
}
