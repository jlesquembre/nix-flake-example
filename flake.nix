{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    graal-nix = {
      url = "github:thiagokokada/graalvm-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, graal-nix }:

    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      compile = pkgs.writeShellScriptBin "compile"
        ''
          javac src/Test.java
          native-image --verbose --static --libc=$LIBC --class-path src Test
        '';
    in
    {

      devShell.x86_64-linux =
        pkgs.mkShell {
          buildInputs = [
            self.packages.x86_64-linux.hello_2_9
            pkgs.cowsay
          ];
        };

      devShells.x86_64-linux = {

        hello = self.devShell.x86_64-linux;

        graal11_21_3 =
          pkgs.mkShell {
            LIBC = "glibc";
            buildInputs = [
              graal-nix.packages.x86_64-linux.graalvm11-ce
              compile
            ];
          };
        graal11_21_3-musl =
          pkgs.mkShell {
            LIBC = "musl";
            buildInputs = [
              graal-nix.packages.x86_64-linux.graalvm11-ce-musl
              compile
            ];
          };
      };

      packages.x86_64-linux = {
        hello_debug = pkgs.hello.overrideAttrs (old: rec {
          separateDebugInfo = true;
        });

        hello_2_9 = pkgs.hello.overrideAttrs (old: rec {
          version = "2.9";
          src = pkgs.fetchurl {
            url = "mirror://gnu/hello/${old.pname}-${version}.tar.gz";
            sha256 = "sha256-7Lt6IhQZbFf/k0CqcUWOFVmr049tjRaWZoRpNd8ZHqc=";
          };
        });
      };
    };
}
