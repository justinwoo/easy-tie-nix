let
  pkgs = import <nixpkgs> { };
in
import
  (pkgs.fetchFromGitHub
    {
      owner = "justinwoo";
      repo = "easy-tie-nix";
      rev = "e92ef16c2ac9964bdb1e27e7eb4b2393ed8a61e0";
      sha256 = "30U5vdHmxVqn0TMxL0TGXKAUkcvHEqH08K0k6checHQ=";
    })
{ }
