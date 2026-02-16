-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Fondo transparente
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- === NORMINETTE (42) ===

-- Tabs reales (OBLIGATORIO)
vim.opt.expandtab = false

-- Cada tab equivale a 4 espacios
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Indentación en C
vim.opt.cindent = true

-- Longitud máxima de línea (Norminette: 80)
vim.opt.textwidth = 80
vim.opt.colorcolumn = "81"

-- Evitar espacios al final de línea
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
}

-- Archivo debe terminar con nueva línea
vim.opt.fixendofline = true
