local wezterm = require("wezterm")
local utils = require("utils")
local act = wezterm.action
local mux = wezterm.mux

---------------------------------------------------------------
--- wezterm on
---------------------------------------------------------------

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-function, unused-local
local function update_tmux_style_tab(window, pane)
	local cwd_uri = pane:get_current_working_dir()
	---@diagnostic disable-next-line: unused-local
	local hostname, cwd = utils.split_from_url(cwd_uri)
	return {
		{ Attribute = { Underline = "Single" } },
		{ Attribute = { Italic = true } },
		{ Text = hostname },
	}
end

-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-local
local function display_copy_mode(window, pane)
	local name = window:active_key_table()
	if name then
		name = "Mode: " .. name
	end
	return { { Attribute = { Italic = false } }, { Text = name or "" } }
end

local io = require("io")
local os = require("os")

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
	local scrollback = pane:get_lines_as_text()
	local name = os.tmpname()
	local f = io.open(name, "w+")
	if f == nil then
		return
	end
	f:write(scrollback)
	f:flush()
	f:close()
	window:perform_action(
		act({
			SpawnCommandInNewTab = {
				args = { "/opt/homebrew/bin/nvim", name },
			},
		}),
		pane
	)
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

-- https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
local hacky_user_commands = {
	-- selene: allow(unused_variable)
	---@diagnostic disable-next-line: unused-local
	["scroll-up"] = function(window, pane, cmd_context)
		window:perform_action(wezterm.action({ ScrollByPage = -1 }), pane)
		-- wezterm.action({ ScrollByPage = -1 })
	end,
	-- selene: allow(unused_variable)
	---@diagnostic disable-next-line: unused-local
	["scroll-down"] = function(window, pane, cmd_context)
		window:perform_action(wezterm.action({ ScrollByPage = 1 }), pane)
	end,
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "hacky-user-command" then
		local cmd_context = wezterm.json_parse(value)
		hacky_user_commands[cmd_context.cmd](window, pane, cmd_context)
		return
	end
end)

require("status_bar")
require("tab_bar")

return {}
