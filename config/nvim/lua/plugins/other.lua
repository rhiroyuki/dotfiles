return {
  "rgroli/other.nvim",
  event = "VeryLazy",
  dev = true,
  config = function()
    require("other-nvim").setup({
      rememberBuffers = false,
      mappings = {
        "livewire",
        "angular",
        "laravel",
        "rails",
        "golang",
        "python",
        "react",
        "rust",
        "elixir",
      },
    })
  end
}
