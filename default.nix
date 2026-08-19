{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  ...
}:
let
  inherit (builtins) readFile;
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs.lib.fileset) toSource;

  nelvim_path = "/home/rodnelkes/Projects/nelvim/nelvim";
  mnw = import sources.mnw;

  kdlSrc = sources.kdl-rs.outPath;
  kdlLspCargoTOML = fromTOML (readFile "${kdlSrc}/tools/kdl-lsp/Cargo.toml");
  kdl-lsp = buildRustPackage {
    pname = kdlLspCargoTOML.package.name;
    version = kdlLspCargoTOML.package.version;
    cargoLock.lockFile = "${kdlSrc}/Cargo.lock";
    src = kdlSrc;
    cargoBuildFlags = [ "-p kdl-lsp" ];
  };

  jj-diffconflicts = buildVimPlugin {
    name = "jj-diffconflicts";
    src = sources.jj-diffconflicts.outPath;
  };
in
mnw.lib.wrap pkgs {
  appName = "nelvim";

  aliases = [
    "vi"
    "vim"
  ];

  initLua = ''require("nelvim")'';

  extraBinPath = with pkgs; [
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
  ];

  plugins = {
    start = with pkgs.vimPlugins; [
      # general
      lualine-nvim
      oil-nvim
      undotree
      fzf-lua
      mini-diff
      mini-git
      mini-hipatterns
      mini-icons
      mini-indentscope
      conform-nvim
      indent-blankline-nvim
      blink-nerdfont-nvim
      jj-nvim
      jj-diffconflicts

      # treesitter
      nvim-treesitter.withAllGrammars

      # colorschemes
      catppuccin-nvim

      # cmp
      blink-cmp
      nvim-cmp
      luasnip
    ];

    dev.nelvim = {
      pure = toSource {
        root = ./.;
        fileset = ./nelvim;
      };
      impure = nelvim_path;
    };
  };
}
