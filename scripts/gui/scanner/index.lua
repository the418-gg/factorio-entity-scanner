local gui = require("__flib__/gui-lite")

local templates = require("__the418_entity_scanner__/scripts/gui/scanner/templates")

local index = {}

--- @param player LuaPlayer
--- @param player_table PlayerTable
function index.new(player, player_table)
  --- @type ScannerGuiElems
  local elems = gui.add(player.gui.screen, templates.render())

  elems.titlebar_flow.drag_target = elems.the418_entity_scanner__scanner_window

  --- @class ScannerGuiData
  local self = {
    player = player,
    player_table = player_table,
    window = elems.the418_entity_scanner__scanner_window,
    elems = elems,
    --- @class ScannerGuiDataState
    state = {
      is_visible = false,
      is_pinned = false,
    },
  }

  player_table.guis.scanner = self
end

return index
