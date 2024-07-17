local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local weather = sbar.add("item", "widgets.weather", {
	position = "right",
	icon = {
		padding_left = 6,
		align = "left",
	},
	background = {
		color = { alpha = 0 },
		border_color = { alpha = 1.0 },
		drawing = true,
	},
	label = {
		padding_right = 8,
		color = colors.blue,
		font = { family = settings.font.numbers, style = settings.font.style_map["Heavy"] },
	},
	update_freq = 300,
	padding_left = 1,
	padding_right = 1,
	popup = { align = "center" },
})

local function extract_icon(data)
	local condition, label = string.match(data, "([^|]+) | ([^|]+)")
	condition = condition:gsub(" ", ""):lower()
	label = label:gsub("+", "")
	local icon = icons.weather[condition]
	if icon == nil then
		icon = condition
	end

	return icon, label
end

local function update_weather()
	sbar.exec("curl -s 'wttr.in/?format=%C+|+%t'", function(data)
		local icon, label = extract_icon(data)
		weather:set({ icon = icon, label = label })
	end)
end

weather:subscribe({ "forced", "routine", "system_woke" }, update_weather)
