require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- === Configuración Escuela 42 ===
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

-- Desactivar autocompletado y virtual text
local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.setup({ completion = { autocomplete = false } })
end
vim.diagnostic.config({ virtual_text = false })
vim.g.deprecation_warnings = false
vim.g.deprecation_warnings = false
