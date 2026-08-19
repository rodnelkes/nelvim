{
  sources,
  pkgs,
}:
let
  inherit (pkgs.vimUtils) buildVimPlugin;

  jj-diffconflicts = buildVimPlugin {
    name = "jj-diffconflicts";
    src = sources.jj-diffconflicts.outPath;
  };
in
with pkgs.vimPlugins;
[
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
]
