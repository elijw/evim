-- ~/.config/nvim/lsp/jdtls.lua

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

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

return {
  cmd = { mason_bin },
  -- force jdtls to use java 21
  cmd_env = {
    JAVA_HOME = "/usr/lib/jvm/java-21-openjdk",
  },
  filetypes = { "java" },
  root_markers = { "settings.gradle.kts", "build.gradle.kts", "pom.xml", ".git" },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      import = { gradle = { enabled = true } },
    },
  },
}
