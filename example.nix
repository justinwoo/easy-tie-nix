let
  pkgs = import <nixpkgs> { };
in
import
  (pkgs.fetchFromGitHub
    {
      owner = "justinwoo";
      repo = "easy-tie-nix";
      rev = "1646bf9103b83192f2f5b97ffd61c114db0656ed";
      sha256 = "sha256-1k72I8/cl7PlbE+7fheJw+G30VVunMdeZlbSXJGK1VA=";
    })
{ }
