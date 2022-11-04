let
  pkgs = import <nixpkgs> { };
in
import
  (pkgs.fetchFromGitHub
    {
      owner = "justinwoo";
      repo = "easy-tie-nix";
      rev = "d227a301912e524d3f04130b4584a523eed67e08";
      sha256 = "1dj8y8c387z7wrkfvrjhvak5xiwxxjz1h0wl6vbzfppnhlz4wd1p";
    })
{ }
