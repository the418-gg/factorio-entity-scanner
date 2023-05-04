local flib_gui = require("__flib__/gui-lite")

local templates = require("__the418_entity_scanner__/scripts/gui/scanner/templates")

local updates = {}

--- @param elem LuaGuiElement
--- @param sprite_name string
--- @param active boolean
function updates.set_frame_action_button_active(elem, sprite_name, active)
  if active then
    elem.style = "flib_selected_frame_action_button"
    elem.sprite = sprite_name .. "_black"
  else
    elem.style = "frame_action_button"
    elem.sprite = sprite_name .. "_white"
  end
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
function updates.redraw_entity_filters(gui, data)
  data.elems.filter_slot_table.clear()
  flib_gui.add(data.elems.filter_slot_table, templates.entity_filter_slot_buttons(gui, data))
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
function updates.redraw_scan_results(gui, data)
  data.elems.results.clear()
  flib_gui.add(data.elems.results, templates.scan_results(gui, data))
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
function updates.redraw_scan_status(gui, data)
  data.elems.scan_status_container.clear()
  flib_gui.add(data.elems.scan_status_container, templates.scan_status(gui, data))

  if data.player_table.scan_status.status == "in_progress" then
    data.elems.action_button.style = "the418_entity_scanner__red_dialog_button"
    data.elems.action_button.caption = { "gui.the418-entity-scanner--scanner-button-scan-off" }
  else
    data.elems.action_button.style = "the418_entity_scanner__green_dialog_button"
    data.elems.action_button.caption = { "gui.the418-entity-scanner--scanner-button-scan-on" }
  end
end

return updates
