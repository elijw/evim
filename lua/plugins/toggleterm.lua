-- plugins.toggleterm

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")
    toggleterm.setup()

    local Terminal = require("toggleterm.terminal").Terminal

    local float_term = Terminal:new({ direction = "float", hidden = true, close_on_exit = true })

    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "float",
      hidden = true,
      close_on_exit = true,
      on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
      end,
    })

    vim.keymap.set("n", "<leader>tt", function()
      toggleterm.toggle()
    end, { desc = "Toggle Terminal" })

    vim.keymap.set("n", "<leader>tf", function()
      float_term:toggle()
    end, { desc = "Toggle Float Terminal" })
  end,
}
