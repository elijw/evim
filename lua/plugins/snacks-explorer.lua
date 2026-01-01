-- plugins.snacks-explorer

return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
  },
  keys = {
    { "<Leader>fe", false },
    { "<Leader>fE", false },
    { "<Leader>e", false },
    { "<Leader>E", false },
  },
}
