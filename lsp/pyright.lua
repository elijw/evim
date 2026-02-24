-- ~/.config/nvim/lsp/pyright.lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"

return {
  cmd = { mason_bin, "--stdio" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        ignore = { "*" },
        typeCheckingMode = "standard",
      },
    },
  },
}
