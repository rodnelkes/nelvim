{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  ...
}:
let
  inherit (pkgs.lib.fileset) toSource;

  mnw = import sources.mnw;
  args = { inherit sources pkgs; };
in
mnw.lib.wrap pkgs {
  appName = "nvim";

  aliases = [
    "vi"
    "vim"
  ];

  luaFiles = [
    ./init.lua
  ];

  plugins = {
    start = import ./nix/start.nix args;

    dev.nelvim = {
      pure = toSource {
        root = ./.;
        fileset = ./nvim;
      };
      impure = "/home/rodnelkes/Projects/nelvim/nvim";
    };
  };

  extraBinPath = import ./nix/binaries.nix args;
}
