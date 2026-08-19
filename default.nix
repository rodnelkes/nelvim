{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  ...
}:
let
  inherit (pkgs.lib.fileset) toSource;

  args = { inherit sources pkgs; };

  mnw = import sources.mnw;
in
mnw.lib.wrap pkgs {
  appName = "nelvim";

  aliases = [
    "vi"
    "vim"
  ];

  initLua = ''require("nelvim")'';

  extraBinPath = import ./nix/binaries.nix args;

  plugins = {
    start = import ./nix/start.nix args;

    dev.nelvim = {
      pure = toSource {
        root = ./.;
        fileset = ./nelvim;
      };
      impure = "/home/rodnelkes/Projects/nelvim/nelvim";
    };
  };
}
