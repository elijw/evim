-- config.lsp

-- based on https://www.youtube.com/watch?v=iaetgcEzByY

-- Copyright 2025 elijw
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Ran into an issue where telescope would sometimes load too late. Added checks.

-- 1. Global Keymaps (This handles gh, gd, etc., for ALL languages including Java)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- disable semantic highlights if preferred
    client.server_capabilities.semanticTokensProvider = nil

    local opts = { buffer = event.buf }

    -- safe telescope loading: check if telescope is available
    local has_telescope, builtin = pcall(require, "telescope.builtin")

    -- keymap helper
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- basic LSP Keymaps (use telescope if available, otherwise native)
    map("n", "gh", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "<F2>", vim.lsp.buf.rename, "Rename Symbol")
    map("n", "<F4>", vim.lsp.buf.code_action, "Code Action")

    if has_telescope then
      map("n", "gd", builtin.lsp_definitions, "Goto Definition (Telescope)")
      map("n", "gi", builtin.lsp_implementations, "Goto Implementation (Telescope)")
      map("n", "gr", builtin.lsp_references, "References (Telescope)")
      map("n", "gs", builtin.lsp_workspace_symbols, "Workspace Symbols (Telescope)")
    else
      -- fallback to native neovim functions if telescope is missing
      map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
      map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "gs", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
    end

    -- diagnostics
    map("n", "g]", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next Diagnostic")
    map("n", "g[", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev Diagnostic")
  end,
})

-- 2. Configure other servers (Except jdtls, which is handled above)
vim.lsp.config("lua_ls", {
  -- paste lua_ls settings/on_init here
})

vim.lsp.config("dartls", {
  settings = { dart = { lineLength = 160 } },
})

vim.lsp.config("eslint", {
  settings = {
    useFlatConfig = true,
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

-- 3. Enable servers
vim.lsp.enable("lua_ls")
vim.lsp.enable("dartls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("csharp_ls")
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("eslint")
