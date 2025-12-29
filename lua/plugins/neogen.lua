-- plugins.neogen

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

return {
  "danymat/neogen",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local neogen = require("neogen")
    local ts = vim.treesitter
    local luasnip = require("luasnip")

    -- utility: find project root by looking for package.json
    local function find_project_root(start_path)
      local path = vim.fn.fnamemodify(start_path, ":p:h") -- start directory
      while path ~= "/" do
        if vim.fn.filereadable(path .. "/package.json") == 1 then
          return path
        end
        path = vim.fn.fnamemodify(path, ":h") -- go one directory up
      end
      return vim.fn.getcwd() -- fallback if package.json not found
    end

    -- utility: relative path from project root
    local function relative_path()
      local file = vim.fn.expand("%:p")
      local root = find_project_root(file)
      return file:sub(#root + 2)
    end

    -- generates header only if cursor on new line at top of file.
    local function generate_file_header()
      local buf = vim.api.nvim_get_current_buf()
      local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
      if row ~= 1 then
        return
      end

      local date = os.date("%m/%d/%Y")
      local header = table.concat({
        "/**",
        " * @author  " .. "elijw",
        " * @file    " .. relative_path(),
        " * @date    " .. date,
        " * @license ",
        " *",
        " * @description ",
        " *",
        " * @todo ",
        " */",
      }, "\n")

      vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.split(header, "\n"))
      vim.api.nvim_win_set_cursor(0, { #vim.split(header, "\n") + 1, 0 })
    end

    -- generate react doc stuff (props/hooks/context)
    local function generate_react_doc(kind)
      local bufnr = vim.api.nvim_get_current_buf()
      local parser = ts.get_parser(bufnr, "typescript") or ts.get_parser(bufnr, "javascript")
      if not parser then
        return
      end

      local root = parser:parse()[1]:root()
      local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

      local query = ts.query.parse(
        "typescript",
        [[
        (variable_declaration
          (variable_declarator
            name: (identifier) @func_name
            value: (arrow_function
                     parameters: (formal_parameters) @params
                   )
          )
        )
        (function_declaration
          name: (identifier) @func_name
          parameters: (formal_parameters) @params
        )
      ]]
      )

      local node_to_doc
      for _, node in query:iter_captures(root, bufnr, 0, -1) do
        local sr, _, er, _ = node:range()
        if sr <= cursor_row and er >= cursor_row then
          node_to_doc = node
          break
        end
      end
      if not node_to_doc then
        return
      end

      local doc_lines = { "/**", " * @description" }

      if kind == "p" then
        local params_node = node_to_doc:field("parameters")[1]
        if params_node then
          for child in params_node:iter_children() do
            local text = ts.get_node_text(child, bufnr)
            table.insert(doc_lines, " * @param " .. text)
          end
        end
      elseif kind == "h" then
        table.insert(doc_lines, " * @returns")
      elseif kind == "c" then
        table.insert(doc_lines, " * @context")
      end

      table.insert(doc_lines, " */")
      table.insert(doc_lines, "")

      local parent = node_to_doc:parent()
      local start_row = parent and select(1, parent:range()) or 0
      vim.api.nvim_buf_set_lines(bufnr, start_row, start_row, false, doc_lines)
    end

    neogen.setup({
      snippet_engine = "luasnip",
      input_after_comment = true,
      languages = {
        javascript = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        tsx = { template = { annotation_convention = "tsdoc" } },
      },
    })

    local opts = { noremap = true, silent = true }

    -- leader keymaps (unchanged)
    vim.keymap.set("n", "<Leader>jf", function()
      neogen.generate({ type = "func" })
    end, vim.tbl_extend("force", opts, { desc = "Function doc" }))
    vim.keymap.set("n", "<Leader>jc", function()
      neogen.generate({ type = "class" })
    end, vim.tbl_extend("force", opts, { desc = "Class doc" }))
    vim.keymap.set(
      "n",
      "<Leader>jh",
      generate_file_header,
      vim.tbl_extend("force", opts, { desc = "File header (top only)" })
    )
    vim.keymap.set("n", "<Leader>jrp", function()
      generate_react_doc("p")
    end, opts)
    vim.keymap.set("n", "<Leader>jrh", function()
      generate_react_doc("h")
    end, opts)
    vim.keymap.set("n", "<Leader>jrc", function()
      generate_react_doc("c")
    end, opts)

    -- Smart <Tab> and <S-Tab> in insert mode
    vim.keymap.set("i", "<Tab>", function()
      if luasnip.expand_or_locally_jumpable() then
        return "<Plug>luasnip-expand-or-jump"
      elseif neogen.jump_next and neogen.jump_next() then
        return ""
      else
        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
      end
    end, { expr = true, silent = true })

    vim.keymap.set("i", "<S-Tab>", function()
      if luasnip.jumpable(-1) then
        return "<Plug>luasnip-jump-prev"
      elseif neogen.jump_prev and neogen.jump_prev() then
        return ""
      else
        return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
      end
    end, { expr = true, silent = true })
  end,
}
