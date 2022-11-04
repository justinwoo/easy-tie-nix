# easy-tie-nix

This is a derivation for consuming [Tie](https://github.com/scarf-sh/tie)

It uses my well-known approach for consuming binaries and patching santa's little ELFs as needed on Linux.

## Example usage

```nix
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
```

## Goals

* Working in some typical way on linux, macos x64 + arm64

## Non-goals

* I am not currently trying to target macos arm64 natively, only that this actually runs. This can be updated when I can get the upstream builds to output the specific architecture (depends on GitHub Actions).
