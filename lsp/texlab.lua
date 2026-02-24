local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/texlab"

return {
  cmd = { mason_bin, "-X", "compile", "%f", "--synctex" },
  settings = {
    texlab = {
      build = {
        executable = "tectonic",
        args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
        onSave = true,
      },
    },
  },
}
