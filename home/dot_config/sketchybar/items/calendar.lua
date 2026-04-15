local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
	icon = {
		color = colors.blue,
		padding_left = 8,
		string = icons.calendar,
		-- font = {
		-- 	style = settings.font.style_map["Black"],
		-- 	size = 12.0,
		-- },
	},
	label = {
		color = colors.white,
		padding_right = 8,
		-- width = 49,
		align = "right",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Heavy"],
		},
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ label = os.date("%a %d %b %H:%M %p") })
end)

-- cal:subscribe("mouse.clicked", function(env)
-- 	local drawing = battery:query().popup.drawing
-- 	battery:set({ popup = { drawing = "toggle" } })
--
-- 	if drawing == "off" then
-- 		sbar.exec("pmset -g batt", function(batt_info)
-- 			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
-- 			local label = found and remaining .. "h" or "No estimate"
-- 			remaining_time:set({ label = label })
-- 		end)
-- 	end
-- end)
