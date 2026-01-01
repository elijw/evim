-- ~/.config/nvim/lsp/ruff.lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ruff"

return {
  cmd = { mason_bin, "server" },
  -- Optional: Disable hover so it doesn't conflict with Pyright's hover
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
