-- Yazi init.lua

-- Git status colors (Ayu Dark flavor palette)
th.git = th.git or {}
th.git.modified = ui.Style():fg("#c2a05c")   -- Yellow/gold
th.git.added = ui.Style():fg("#7e9350")      -- Green
th.git.untracked = ui.Style():fg("#1f6f88")  -- Teal
th.git.deleted = ui.Style():fg("#a85361")    -- Red
th.git.updated = ui.Style():fg("#1f6f88")    -- Teal
th.git.ignored = ui.Style():fg("#5c6773")    -- Dim gray

require("git"):setup()
require("full-border"):setup()
require("no-status"):setup()

-- fg.yazi: fzf-powered search
-- Options: "menu" (choose action), "nvim" (open in editor), "jump" (navigate in yazi)
require("fg"):setup({
    default_action = "menu",
})
