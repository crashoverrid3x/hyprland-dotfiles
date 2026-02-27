return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- que cargue primero
    lazy = false, -- evita carga perezosa porque es tu theme principal
    config = function()
      require("onedarkpro").setup({
        options = {
          transparency = false, -- haz true si quieres fondo transparente
          terminal_colors = true,
          highlight_inactive_windows = false,
        },
        colors = {},
        highlights = {},
        plugins = {
          treesitter = true,
          nvim_lsp = true,
        },
      })
      -- establece OneDark Pro como tema
      vim.cmd("colorscheme onedark")
    end,
  },
}
