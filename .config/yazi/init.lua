-- Yazi init.lua

-- Git status colors (Ayu Dark palette)
th.git = th.git or {}
th.git.modified = ui.Style():fg("#e6b450")   -- Yellow
th.git.added = ui.Style():fg("#aad94c")      -- Green
th.git.untracked = ui.Style():fg("#95e6cb")  -- Cyan
th.git.deleted = ui.Style():fg("#f07178")    -- Red
th.git.updated = ui.Style():fg("#59c2ff")    -- Blue
th.git.ignored = ui.Style():fg("#5c6773")    -- Dim gray

require("git"):setup()
require("full-border"):setup()
require("no-status"):setup()
