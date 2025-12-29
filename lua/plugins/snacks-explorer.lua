-- plugins.snacks-explorer

return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
  },
  keys = {
    { "<Leader>e", false },
    { "<Leader>E", false },
  },
}
