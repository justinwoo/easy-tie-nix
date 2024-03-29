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

  version = "20240321";

  buildInputs = [ pkgs.gmp  ];

  libPath = pkgs.lib.makeLibraryPath buildInputs;

  src =
    if pkgs.stdenv.isDarwin
    then
      pkgs.fetchzip
        {
          url = "justin.gateway.scarf.sh/easy-tie-nix/macos-latest/20240321.tar.gz";
          sha256 = "zlGV3OZ1ZcLraJEcWse/sri984mmnEW6bmrhk0C2QEY=";
        }
    else
      pkgs.fetchzip {
        url = "justin.gateway.scarf.sh/easy-tie-nix/ubuntu-latest/20240321.tar.gz";
        sha256 = "SaTC7ItBt0RY7bPZKBsEp/uFYtzk3Xi3EAc2Pn2FoRo=";
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
