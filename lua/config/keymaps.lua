-- config.keymaps

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

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.del("n", "<Leader>e")
-- vim.keymap.del("n", "<Leader>E")

vim.keymap.set("n", "<Leader>ee", ":Neotree source=filesystem<CR>", { desc = "Open Neotree (FS)" })
vim.keymap.set("n", "<Leader>eb", ":Neotree source=buffers<CR>", { desc = "Open Neotree (Buf)" })
vim.keymap.set("n", "<Leader>eg", ":Neotree source=git_status<CR>", { desc = "Open Neotree (Git)" })

-- local cmp = require("cmp")
-- cmp.setup({
--   mapping = {
--     ["<Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--
--     ["<S-Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end, { "i", "s" }),
--   },
-- })
