-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "tomorrow_night",
  transparency = false,

  hl_override = {
    Normal = { bold = false },
    Comment = { italic = true },
    ["@comment"] = { italic = true, bold = false },
  },
  nvdash = {
    load_on_startup = true,

    -- header = {
    --  "                                                          ",
    --  "       ..:::.             .:::..           .:--:..        ",
    --  "      :=++++++:         .=++++++.        .++*####*:       ",
    --  "     :-++++++++.       .=++++++++.       ++*#######-      ",
    --  "     :-++++++++=      .-+++++++++=.     -*+########=      ",
    --  "     .+-++++++++:     :+++++++++++:    .*-#########:      ",
    --  "      .==++++++++.   :++++++++++=++.   -=*########=       ",
    --  "       -=++++++++-. .=+++++++=+++++=. .++########*        ",
    --  "       .-=+++++++=..-+++++++=+--++++:.-*#########-        ",
    --  "       .-:++++++++:.+++++++==-+#####*--#########+.        ",
    --  "        .+=+++++++:++++++++==-######**-=########-         ",
    --  "         .+=+++++==+++++++==.+#######=*:*######+          ",
    --  "          :=++++--+++++++==:.=########=+:*#####.          ",
    --  "          .....-++++++++=-=. .+########++.*###=           ",
    --  "          .-++++++++++++=+.   :########*=+-##*:           ",
    --  "           .+++++++++++==.     :########*==-#=.           ",
    --  "            -+++++++++==:       =########*+:=.            ",
    --  "            .=+++++++==-.       .+########*+              ",
    --  "             :+++++++=+.         :########*+              ",
    --  "             .-+++++=+.           -#######*:              ",
    --  "              .===++=.             -######=.              ",
    --  "                ....                .:--:.                ",
    --  "                                                          ",
    -- },
    header = {
      "                                                                                                       ",
      "                                                                                                       ",
      " ++++++      +++++     #++####       +++++++++++++       +++++               ++++++    ++++++++++++    ",
      " -++++++    +++++++    ++#####    +++++++++++++++++++   +++++++             ++++++++  +++++++++++++++  ",
      " +++++++   +++++++++  #+######  ++++++++++++++++++++++  ++++++++    ++++    ++++++++  +++++++++++++++  ",
      " ++++++++ +++++++++++ ++#####  ++++++++++    ++++++++++ +++++++++ ++++++++ ++++++++    +++    +++++++  ",
      "  +++++++++++++-+###+#+######  ++++++++         +++++++  ++++++++ +++++++++++++++++           +++++++  ",
      "   +++++++++++-+####++######  ++++++++          ++++++++  ++++++++++++++++++++++++        +++++++++    ",
      "   ++++++++++++ #####+######  ++++++++          ++++++++  ++++++++++++++++++++++++        +++++++++++  ",
      "    +++++++++-+ ######+####    ++++++++        ++++++++    ++++++++++++++++++++++             +++++++  ",
      "     +++++++-+   ######+##     ++++++++++    ++++++++++    +++++++++++++++++++++      +++     +++++++  ",
      "     ++++++-+     ######+#       +++++++++++++++++++++      ++++++++++++++++++++    +++++++++++++++++  ",
      "     +++++++      ######++        ++++++++++++++++++         ++++++++  ++++++++     +++++++++++++++++  ",
      "      +++++        ######            +++++++++++++            ++++++    ++++++        +++++++++++++    ",
      "                                                                                                       ",
      "                                                                                                       ",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}

return M