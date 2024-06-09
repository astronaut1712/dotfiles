local wezterm = require("wezterm")

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local VIM_ICON = wezterm.nerdfonts.linux_neovim
local FUZZY_ICON = utf8.char(0xf0b0)
local HOURGLASS_ICON = utf8.char(0xf252)
local SUNGLASS_ICON = utf8.char(0xf9df)

local K8S_ICON = wezterm.nerdfonts.md_kubernetes
local LUA_ICON = wezterm.nerdfonts.seti_lua
local SHELL_ICON = wezterm.nerdfonts.dev_terminal
local MAKEFILE_ICON = wezterm.nerdfonts.seti_makefile
local PYTHON_ICON = wezterm.nerdfonts.dev_python
local NODE_ICON = wezterm.nerdfonts.dev_nodejs_small
local DOCKER_ICON = wezterm.nerdfonts.seti_docker
local GOLANG_ICON = wezterm.nerdfonts.seti_go
local GIT_ICON = wezterm.nerdfonts.seti_git

local SUB_IDX = {"₁","₂","₃","₄","₅","₆","₇","₈","₉","₁₀",
                 "₁₁","₁₂","₁₃","₁₄","₁₅","₁₆","₁₇","₁₈","₁₉","₂₀"}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local edge_background = "#2e3440"
  local background = "#4E4E4E"
  local foreground = "#1C1B19"
  local dim_foreground = "#3A3A3A"

  if tab.is_active then
    background = "#FBB829"
    foreground = "#1C1B19"
  elseif hover then
    background = "#FF8700"
    foreground = "#1C1B19"
  end

  local edge_foreground = background
  local process_name = tab.active_pane.foreground_process_name
  local pane_title = tab.active_pane.title
  local exec_name = basename(process_name):gsub("%.exe$", "")
  local title_with_icon

  if exec_name == "nvim" then
    title_with_icon = VIM_ICON .. " " .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
  elseif exec_name == "zsh" or exec_name == "bash" then
    title_with_icon = SHELL_ICON.. " " .. exec_name:upper()
  elseif exec_name == "lua" then
    title_with_icon = LUA_ICON.. " " .. exec_name
  elseif exec_name == "make" then
    title_with_icon = MAKEFILE_ICON.. " " .. exec_name
  elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
    title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
  elseif exec_name == "k9s" or exec_name == "helm" or exec_name == "kubectl" then
    title_with_icon = K8S_ICON .. " " .. exec_name:upper()
  elseif exec_name == "btm" or exec_name == "ntop" then
    title_with_icon = SUNGLASS_ICON .. " " .. exec_name:upper()
  elseif exec_name == "Python" or exec_name == "hiss" then
    title_with_icon = PYTHON_ICON .. " " .. exec_name
  elseif exec_name == "go" or exec_name == "gofmt" then
    title_with_icon = GOLANG_ICON.. " " .. exec_name
  elseif exec_name == "git" or exec_name == "tig" then
    title_with_icon = GIT_ICON.. " " .. exec_name
  elseif exec_name == "node" then
    title_with_icon = NODE_ICON .. " " .. exec_name:upper()
  elseif exec_name == "docker" or exec_name == "docker-compose" then
    title_with_icon = DOCKER_ICON.. " " .. exec_name:upper()
  else
    title_with_icon = HOURGLASS_ICON .. " " .. exec_name
  end
  local left_arrow = SOLID_LEFT_ARROW
  if tab.tab_index == 0 then
    left_arrow = SOLID_LEFT_MOST
  end
  local id = SUB_IDX[tab.tab_index+1]
  local title = " " .. wezterm.truncate_right(title_with_icon, max_width-6) .. " "

  return {
    {Attribute={Intensity="Bold"}},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=left_arrow},
    {Background={Color=background}},
    {Foreground={Color=foreground}},
    {Text=id},
    {Text=title.." "},
    {Foreground={Color=dim_foreground}},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_RIGHT_ARROW},
    {Attribute={Intensity="Normal"}},
  }
end)
