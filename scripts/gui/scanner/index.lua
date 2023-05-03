local flib_gui = require("__flib__/gui-lite")

local gui = require("__the418_entity_scanner__/scripts/gui/scanner/gui")
local templates = require("__the418_entity_scanner__/scripts/gui/scanner/templates")

local index = {}

--- @param player LuaPlayer
--- @param player_table PlayerTable
function index.new(player, player_table)
  --- @class ScannerGuiData
  local self = {
    player = player,
    player_table = player_table,
    window = {}, --- @type LuaGuiElement
    elems = {}, --- @type ScannerGuiElems
    --- @class ScannerGuiDataState
    state = {
      is_visible = false,
      is_pinned = false,
    },
  }

  --- @type ScannerGuiElems
  local elems = flib_gui.add(player.gui.screen, templates.render(gui, self))

  self.elems = elems
  self.window = elems.the418_entity_scanner__scanner_window

  player_table.guis.scanner = self
end

return index
