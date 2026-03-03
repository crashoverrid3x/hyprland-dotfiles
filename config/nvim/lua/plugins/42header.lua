
return {

  {

    "42Paris/42header",

    lazy = false,

    config = function()

      -- El comando para insertar el header será :Stdheader

      -- Pero también lo mapeamos a la tecla F1

      vim.keymap.set("n", "<F1>", ":Stdheader<CR>", { silent = true })

    end,

  },

}

