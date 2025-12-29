-- plugins.java

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      -- creates a unique workspace for every project to prevent cache corruption
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

      local config = {
        cmd = {
          -- absolute path to Mason binary
          vim.fn.stdpath("data") .. "/mason/bin/jdtls",
          "-data",
          workspace_dir,
        },
        -- ARCH LINUX FIX: Force Java 21 for the server
        cmd_env = {
          JAVA_HOME = "/usr/lib/jvm/java-21-openjdk",
        },
        root_dir = vim.fs.root(0, { ".git", "gradlew", "mvnw", "build.gradle.kts", "settings.gradle.kts" }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            import = {
              gradle = {
                enabled = true,
                wrapper = {
                  enabled = true,
                },
              },
            },
          },
        },
      }

      -- attach jdtls when opening a Java file
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  },
}
