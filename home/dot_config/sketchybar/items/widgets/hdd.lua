local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "hdd_update" for
-- the hdd load data, which is fired every 2.0 seconds.
sbar.exec("killall hdd_load >/dev/null; $CONFIG_DIR/helpers/event_providers/hdd_load/bin/hdd_load hdd_update 2.0")
local hdd = sbar.add("item", "widgets.hdd", {
	position = "right",
	icon = { string = icons.hdd, color = colors.green },
	label = {
		string = "??G",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Heavy"],
		},
	},
	update_freq = 180,
	popup = { align = "center" },
})

hdd:subscribe("hdd_update", function(env)
	local load = tonumber(env.percent_used)

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	hdd:set({
		label = env.available .. "G",
		icon = { color = color },
	})
end)

hdd:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the hdd item
sbar.add("bracket", "widgets.hdd.bracket", { hdd.name }, {
	background = { color = colors.bg1 },
})

-- Background around the hdd item
sbar.add("item", "widgets.hdd.padding", {
	position = "right",
	width = settings.group_paddings,
})
