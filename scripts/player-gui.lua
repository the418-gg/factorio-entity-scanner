local flib_gui = require("__flib__/gui-lite")

local player_data = require("__the418_entity_scanner__/scripts/player-data")
local scanner_gui = require("__the418_entity_scanner__/scripts/gui/scanner/gui")
local scanner_gui_index = require("__the418_entity_scanner__/scripts/gui/scanner/index")

local player_gui = {}

--- @param player LuaPlayer
--- @param player_table PlayerTable
function player_gui.refresh(player, player_table)
  local scanner_gui_data = player_table.guis.scanner
  if scanner_gui_data then
    scanner_gui.destroy(scanner_gui_data)
  end
  scanner_gui_index.new(player, player_table)
end

--- @param player_index uint
--- @param gui_name "scanner"
--- @return ScannerGuiData?
function player_gui.get_gui_data(player_index, gui_name)
  local player_table = global.players[player_index]
  if player_table then
    local Gui = player_table.guis[gui_name]
    if Gui and Gui.window.valid then
      return Gui
    end
  end
end

--- @param player_index uint
function player_gui.toggle_interface(player_index)
  local scanner_gui_data = player_gui.get_gui_data(player_index, "scanner")
  if scanner_gui_data then
    scanner_gui.toggle(scanner_gui_data)
  else
    local player = game.get_player(player_index)
    if player then
      local player_table = global.players[player_index]
      player_data.refresh(player, player_table)
    end
  end
end

--- @param player_index uint
function player_gui.update_scan_status(player_index)
  local scanner_gui_data = player_gui.get_gui_data(player_index, "scanner")
  if scanner_gui_data then
    scanner_gui.update_scan_status(scanner_gui_data)
  end
end

--- @param Gui ScannerGui
local function register_handler(Gui)
  flib_gui.add_handlers(Gui, function(event, handler)
    local data = player_gui.get_gui_data(event.player_index, "scanner")
    if data then
      handler(data, event)
    end
  end)
end

function player_gui.register_handlers()
  register_handler(scanner_gui)
end

return player_gui
