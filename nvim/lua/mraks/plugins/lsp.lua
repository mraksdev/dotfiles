return {
  -- LSP configs and Mason manager
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "stylua",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {}
      },
      "neovim/nvim-lspconfig",
    },
  }
}
