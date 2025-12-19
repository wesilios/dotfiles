-- lua/plugins/configs/render-markdown.lua
local M = {}

function M.setup()
  require('render-markdown').setup({
    -- Enable/disable rendering on startup
    enabled = true,

    -- Maximum file size to render (in MB)
    max_file_size = 10.0,

    -- Debounce rendering (ms)
    debounce = 100,

    -- Heading configuration
    heading = {
      -- Turn on / off heading icon & background rendering
      enabled = true,
      -- Turn on / off any sign column related rendering
      sign = true,
      -- Replaces '#+' of 'atx_h._marker'
      -- The number of '#' in the heading determines the 'level'
      -- The 'level' is used to index into the array using a cycle
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      -- Added to the sign column if enabled
      -- The 'level' is used to index into the array using a cycle
      signs = { '󰫎 ' },
      -- Width of the heading background:
      --  block: width of the heading text
      --  full: full width of the window
      width = 'full',
      -- The 'level' is used to index into the array using a clamp
      -- Highlight for the heading icon and extends through the entire line
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
      -- The 'level' is used to index into the array using a clamp
      -- Highlight for the heading and sign icons
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
    },

    -- Code block configuration
    code = {
      -- Turn on / off code block & inline code rendering
      enabled = true,
      -- Turn on / off any sign column related rendering
      sign = true,
      -- Determines how code blocks & inline code are rendered:
      --  none: disables all rendering
      --  normal: adds highlight group to code blocks & inline code
      --  language: adds language icon to sign column if enabled and icon + name above code blocks
      --  full: normal + language
      style = 'full',
      -- Width of the code block background:
      --  block: width of the code block
      --  full: full width of the window
      width = 'full',
      -- Highlight for code blocks
      highlight = 'RenderMarkdownCode',
    },

    -- Bullet list configuration
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
      -- Replaces '-'|'+'|'*' of 'list_item'
      -- How deeply nested the list is determines the 'level'
      -- The 'level' is used to index into the array using a cycle
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
      icons = { '●', '○', '◆', '◇' },
      -- Highlight for the bullet icon
      highlight = 'RenderMarkdownBullet',
    },

    -- Checkbox configuration
    checkbox = {
      -- Turn on / off checkbox state rendering
      enabled = true,
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'
        icon = '󰄱 ',
        -- Highlight for the unchecked icon
        highlight = 'RenderMarkdownUnchecked',
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'
        icon = '󰱒 ',
        -- Highlight for the checked icon
        highlight = 'RenderMarkdownChecked',
      },
      -- Define custom checkbox states, more involved as they are not part of the markdown grammar
      -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
      -- Can specify as many additional states as you like following the 'todo' pattern below
      --   The key in this case 'todo' is for healthcheck and to allow users to change its values
      --   'raw': Matched against the raw text of a 'shortcut_link'
      --   'rendered': Replaces the 'raw' value when rendering
      --   'highlight': Highlight for the 'rendered' icon
      custom = {
        todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
      },
    },

    -- Table configuration
    pipe_table = {
      -- Turn on / off table rendering
      enabled = true,
      -- Determines how the table as a whole is rendered:
      --  none: disables all rendering
      --  normal: applies the 'cell' style rendering to each row of the table
      --  full: normal + a top & bottom line that fill out the table when lengths match
      style = 'full',
      -- Determines how individual cells of a table are rendered:
      --  overlay: writes completely over the table, removing conceal behavior and highlights
      --  raw: replaces only the '|' characters in each row, leaving the cells unmodified
      --  padded: raw + cells are padded with inline extmarks to make up for any concealed text
      cell = 'padded',
      -- Characters used to replace table border
      -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
      -- stylua: ignore
      border = {
        '┌', '┬', '┐',
        '├', '┼', '┤',
        '└', '┴', '┘',
        '│', '─',
      },
      -- Highlight for table heading, delimiter, and the line above
      head = 'RenderMarkdownTableHead',
      -- Highlight for everything else, main table rows and the line below
      row = 'RenderMarkdownTableRow',
    },

    -- Callout configuration
    callout = {
      note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
      tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
      important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
      warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
      caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    },
  })
end

-- Keymaps
local map = vim.keymap.set

map('n', '<leader>mt', ':RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Rendering' })
map('n', '<leader>me', ':RenderMarkdown enable<CR>', { desc = 'Enable Markdown Rendering' })
map('n', '<leader>md', ':RenderMarkdown disable<CR>', { desc = 'Disable Markdown Rendering' })

return M

