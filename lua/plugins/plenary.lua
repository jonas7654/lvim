return {
  -- Plenary – a Lua utility library used by many plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = false, -- load it immediately (you can set true if you only need it on demand)
    priority = 1000, -- make sure it loads before plugins that depend on it
    config = function()
      -- optional: you can expose the module globally if you like
      -- vim.g.loaded_plenary = true
    end,
  },
}
