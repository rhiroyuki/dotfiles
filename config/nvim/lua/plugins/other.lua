return {
  "rgroli/other.nvim",
  event = "VeryLazy",
  dev = true,
  config = function()
    require("other-nvim").setup({
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
