# Indentation & Column Width Configuration Guide

## Current Settings

### Indentation Rules
- **2 spaces**: JavaScript, TypeScript, Lua, JSON, HTML, CSS, YAML, Markdown, Vue
- **4 spaces**: C#, C, C++, Python, Java, Go, Rust, PHP, Ruby, Shell, Vim, SQL

### Column Width
- **All files**: 120 characters (with visual guide)

## How to Modify

### Main Configuration File
**Edit**: `lua/core/filetype-settings.lua` (single source of truth)

### Change Indentation for a Language
Move the filetype between groups:
```lua
M.indent_settings = {
  ['2_spaces'] = {
    indent = 2,
    filetypes = { 'lua', 'javascript', 'typescript', ... },
  },
  ['4_spaces'] = {
    indent = 4,
    filetypes = { 'cs', 'c', 'cpp', 'python', ... },
  },
}
```

**Example**: Change C# from 4 to 2 spaces:
- Remove `'cs'` from `4_spaces` filetypes
- Add `'cs'` to `2_spaces` filetypes

### Change Global Column Width
```lua
M.defaults = {
  textwidth = 120,      -- Change this number
  colorcolumn = '120',  -- Change to match
  default_indent = 4,
}
```

Also update formatter configs:
- `.prettierrc.json`: `"printWidth": 120`
- `stylua.toml`: `column_width = 120`

### Override Column Width for Specific Language
```lua
M.textwidth_overrides = {
  python = 88,    -- Example: Python with Black formatter
  cs = 100,       -- Example: C# with 100 chars
}
```

## Configuration Files

| File | Purpose |
|------|---------|
| `lua/core/filetype-settings.lua` | ⭐ Main config - modify this |
| `lua/core/options.lua` | Global defaults |
| `lua/plugins/configs/conform.lua` | Formatter settings |
| `.prettierrc.json` | Prettier (JS/TS/CSS/HTML) |
| `stylua.toml` | Stylua (Lua) |
| `.editorconfig` | EditorConfig (C#, cross-editor) |
| `.clang-format` | Clang-Format (C/C++) |

## Commands

### Format
- `<leader>cf` - Format current buffer
- Auto-format on save (enabled by default)

### Comment/Uncomment Code
- `gcc` - Toggle comment on current line (normal mode)
- `gc` - Toggle comment on selected lines (visual mode)
- `gbc` - Toggle block comment (normal mode)
- `gb` - Toggle block comment (visual mode)
- `gco` - Add comment on line below
- `gcO` - Add comment on line above
- `gcA` - Add comment at end of line

### Check Settings
```vim
:set shiftwidth?    " Check indent width
:set textwidth?     " Check max line length
:set colorcolumn?   " Check visual guide
:set filetype?      " Check detected filetype
```

## Troubleshooting

**Wrong indentation?**
```vim
:set filetype?      " Check filetype detection
:source $MYVIMRC    " Reload config
```

**Formatter not working?**
```vim
:Mason              " Check installed formatters
:LspInfo            " Check LSP status
```

## Quick Examples

### Example 1: Change all to 100 column width
1. Edit `lua/core/filetype-settings.lua`:
   ```lua
   M.defaults = { textwidth = 100, colorcolumn = '100', default_indent = 4 }
   ```
2. Edit `.prettierrc.json`: `"printWidth": 100`
3. Edit `stylua.toml`: `column_width = 100`
4. Restart Neovim

### Example 2: Add 3-space indent group
Edit `lua/core/filetype-settings.lua`:
```lua
M.indent_settings = {
  ['2_spaces'] = { ... },
  ['4_spaces'] = { ... },
  ['3_spaces'] = {
    indent = 3,
    filetypes = { 'mylang' },
  },
}
```

---

**Remember**: `lua/core/filetype-settings.lua` is your single source of truth for indentation and column width settings.

