-- ~/.config/nvim/lsp/ruff.lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ruff"

return {
  cmd = { mason_bin, "server" },
  -- disable hover so it doesn't conflict with pyright's hover
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
