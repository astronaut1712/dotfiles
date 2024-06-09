local wezterm = require("wezterm")

local theme = {
  ansi = {
    "#0d0c0c",
    "#c4747e",
    "#8a9a7b",
    "#c4b28a",
    "#8ba4b0",
    "#a292a3",
    "#8ea4a2",
    "#C8C093",
  },

  brights = {
    "#a6a69c",
    "#E46876",
    "#87a987",
    "#E6C384",
    "#7FB4CA",
    "#938AA9",
    "#7AA89F",
    "#c5c9c5",
  },

  indexed = { [16] = "#b6927b", [17] = "#b98d7b" },
}

local modes = {
  copy_mode = { text = " 󰆏 COPY ", bg = theme.brights[3] },
  search_mode = { text = " 󰍉 SEARCH ", bg = theme.brights[4] },
  window_mode = { text = " 󱂬 WINDOW ", bg = theme.ansi[6] },
  font_mode = { text = " 󰛖 FONT ", bg = theme.indexed[16] or theme.ansi[8] },
  lock_mode = { text = "  LOCK ", bg = theme.ansi[8] },
}

local function get_battery_status()
  for _, b in ipairs(wezterm.battery_info()) do
    if b.state == 'Charging' then
      if b.state_of_charge == 1.0 then return ' '..wezterm.nerdfonts.md_battery_charging end
    end
    if b.state == 'Full' then
      return ' '..wezterm.nerdfonts.md_battery
    end
    local charging_status = string.format('%.0f%%', b.state_of_charge * 100)
    local state = '90'
    if b.state_of_charge > 0.9 then
      return ' '..wezterm.nerdfonts.md_battery..' '..charging_status
    end
    if b.state_of_charge >= 0.8 and b.state_of_charge < 0.9 then state = '80'
      elseif  b.state_of_charge >= 0.7 then state = '70'
      elseif b.state_of_charge >= 0.5 then state = '50'
      elseif b.state_of_charge >= 0.3 then state = '30'
      elseif b.state_of_charge < 0.3 then state = '10'
    end
    if b.state == 'Charging' then
      return ' '..wezterm.nerdfonts['md_battery_charging_'..state]..' '..charging_status
    else
      return ' '..wezterm.nerdfonts['md_battery_'..state]..' '..charging_status
    end
  end
end

wezterm.on('update-right-status', function(window, pane)
  local cwd = pane:get_current_working_dir().file_path:gsub('^'..wezterm.home_dir, '~').." "
  if string.len(cwd) > 30 then
    cwd = cwd:gsub('/.*/','/.../')
  end
	local date = wezterm.strftime(wezterm.nerdfonts.fa_calendar.." %I:%M:%S %p  %a  %B %-d ");
  local hostname = wezterm.hostname()
  local bat = get_battery_status()

  -- colors config
  local bgLast = '#3b4252'
  local bgFirst = '#465780'
  local bgSecond = '#818181'

  -- Make it italic and underlined
  window:set_right_status(
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color=bgLast}},
			{Background={Color="#2e3440"}},
			{Text=""},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color="#ffffff"}},
			{Background={Color=bgLast}},
			{Text=cwd},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color=bgSecond}},
			{Background={Color=bgLast}},
			{Text=""},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color="#ffffff"}},
			{Background={Color=bgSecond}},
			{Text=date},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color=bgFirst}},
			{Background={Color=bgSecond}},
			{Text=""},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color="#ebcb8b"}},
			{Background={Color=bgFirst}},
			{Text=bat.." "},
		})..
		wezterm.format({
      {Attribute={Intensity="Bold"}},
			{Foreground={Color="#000000"}},
			{Background={Color="#ebcb8b"}},
			{Text=wezterm.nerdfonts.cod_account.." "..hostname.." "..wezterm.nerdfonts.dev_apple.." "},
		})
  )
end)
