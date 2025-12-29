-- config.functions

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

local M = {}

function M.copy_diagnostics()
  local diags = vim.diagnostic.get(0)
  local lines = {}
  local max_lines = 50
  local count = 0

  for _, d in ipairs(diags) do
    if count >= max_lines then
      break
    end
    table.insert(
      lines,
      string.format(
        "%d:%d [%s] %s",
        d.lnum + 1,
        d.col + 1,
        vim.diagnostic.severity[d.severity] or d.severity,
        d.message
      )
    )
    count = count + 1
  end

  vim.fn.setreg("+", table.concat(lines, "\n"))
  print(string.format("Copied %d diagnostics to clipboard", count))
end

function M.setup()
  vim.api.nvim_create_user_command("CopyDiagnostics", M.copy_diagnostics, {})
end

return M
