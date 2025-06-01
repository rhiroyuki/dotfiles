local M = {}

--- Maps a keybinding in Neovim.
---
--- This function simplifies the process of setting key mappings by merging
--- default options with user-provided options and calling `vim.api.nvim_set_keymap`.
---
--- @param mode string: The mode in which the keybinding is active (e.g., "n", "i", "v").
--- @param key string: The key or key combination to map.
--- @param command string|function: The command or Lua function to execute when the key is pressed.
--- @param opts table|nil: A table of options for the keymap (optional).
M.map = function(mode, key, command, opts)
  local merged_opts = vim.tbl_deep_extend("force", { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode, key, command, merged_opts)
end

--- Default capabilities for LSP clients.
M.default_capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  {
    textDocument = {
      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          deprecatedSupport = true,
          preselectSupport = true,
          tagSupport = {
            valueSet = {
              1,
            }
          },
          insertReplaceSupport = true,
          resolveSupport = {
            properties = {
              "documentation",
              "additionalTextEdits",
              "insertTextFormat",
              "insertTextMode",
              "command",
            },
          },
          insertTextModeSupport = {
            valueSet = {
              1,
              2,
            }
          },
          labelDetailsSupport = true,
        },
        contextSupport = true,
        insertTextMode = 1,
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          }
        }
      },
    },
  }
)

---  Setup capabilities for LSP clients.
---
---  This function merges the default capabilities with any user-defined capabilities.
---
---  @param capabilities table: A table containing user-defined capabilities to extend the default ones.
---  @return table: A new table containing the merged capabilities.
M.setup_capabilities = function(capabilities)
  return vim.tbl_deep_extend(
    "force",
    M.default_capabilities,
    capabilities
  )
end

--- Checks if a Lua module exists.
---
--- This function iterates through the package loaders to determine if a module can be loaded.
---
--- @param name string: The name of the module to check.
--- @return boolean: Returns true if the module exists, false otherwise.
M.module_exists = function (name)
  for _, searcher in ipairs(package.loaders) do
    local loader = searcher(name)
    if type(loader) == "function" then
      return true
    end
  end
  return false
end

return M
