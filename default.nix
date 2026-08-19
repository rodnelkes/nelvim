{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  ...
}:
let
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs.lib.fileset) toSource;

  args = { inherit sources pkgs; };

  mnw = import sources.mnw;

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

  extraBinPath = import ./nix/binaries.nix args;

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
      impure = "/home/rodnelkes/Projects/nelvim/nelvim";
    };
  };
}
