local scanner_gui_index = require("__the418_entity_scanner__/scripts/gui/scanner/index")
local scanner_gui = require("__the418_entity_scanner__/scripts/gui/scanner/gui")

local player_data = {}

--- @param player LuaPlayer
function player_data.init(player)
  --- @class PlayerTable
  global.players[player.index] = {
    --- @type PlayerGuis
    guis = {},
    --- @type string[]
    entity_filters = {},
  }
end

--- @param player LuaPlayer
--- @param player_table PlayerTable
function player_data.refresh(player, player_table)
  local scanner_gui_data = player_table.guis.scanner
  if scanner_gui_data then
    scanner_gui.destroy(scanner_gui_data)
  end
  scanner_gui_index.new(player, player_table)
end

--- @class PlayerGuis
--- @field scanner ScannerGuiData

return player_data
