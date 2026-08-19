{
  sources,
  pkgs,
}:
let
  inherit (builtins) readFile;
  inherit (pkgs.rustPlatform) buildRustPackage;

  kdlSrc = sources.kdl-rs.outPath;
  kdlLspCargoTOML = fromTOML (readFile "${kdlSrc}/tools/kdl-lsp/Cargo.toml");
  kdl-lsp = buildRustPackage {
    pname = kdlLspCargoTOML.package.name;
    version = kdlLspCargoTOML.package.version;
    cargoLock.lockFile = "${kdlSrc}/Cargo.lock";
    src = kdlSrc;
    cargoBuildFlags = [ "-p kdl-lsp" ];
  };
in
with pkgs;
[
  # bash
  bash-language-server
  shfmt

  # c/c++
  clang-tools

  # kdl
  kdl-lsp
  kdlfmt

  # lua
  lua-language-server
  stylua

  # nix
  nixd
  nixfmt

  # nu
  nushell
  nufmt

  # python
  basedpyright
  ruff

  # qml
  kdePackages.qtdeclarative

  # yaml
  yaml-language-server
  yamlfmt
]
