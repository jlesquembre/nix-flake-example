# Usage

To get a shell with graalvm run:

```bash
nix develop .#graal11_21_3-musl
```

2 more dev shells are provided, `graal11_21_3` and `hello`

A helper script, `compile`, can be used inside the nix shell

# Override derivation

To override a derivation, we can use 2 functions, `override` and
`overrideAttrs`:

```nix
{ stdenv, bar, baz }: # this part gets overriden by `override`
stdenv.mkDerivation { # This part gets overriden by `overrideAttrs`
  pname = "test";
  version = "0.0.1";
  buildInputs = [bar baz];
  phases = ["installPhase"];
  installPhase = "touch $out";
}
```

There are 2 example in this flake, `hello_2_9` and `hello_debug`

# Nix NOTES

- New command vs old commands

  `nix ...` are the new nix (flakes) commands, while `nix-...` are the old nix
  commands. Notice the space vs the `-` after the `nix`. E.g.:

  - NEW: `nix shell nixpkgs#hello`
  - OLD: `nix-shell -p hello`

  Those 2 commands are more or less equivalent

  Docs for the new commands:
  [nix new CLI](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix.html)

- How is `nixpkgs#hello` resolved?

  Nix looks into the nix registry. We can see all the entries with
  `nix registry list`. To add a new entry we can run
  `nix registry add nixpkgs ~/nixpkgs`. To reference the flake in the current
  directory use `.`.

  Some examples:

  - `nix shell nixpkgs#hello`: `hello` from the `nixpkgs` registry flake
  - `nix shell .#hello`: `hello` from the flake in the current directory
