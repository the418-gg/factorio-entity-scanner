local updates = require("__the418_entity_scanner__/scripts/gui/scanner/updates")

--- @class ScannerGui
local scanner_gui = {}

--- @param data ScannerGuiData
function scanner_gui.open(data)
  data.window.bring_to_front()
  data.window.visible = true
  data.state.is_visible = true
  data.player.opened = data.window
  data.player.set_shortcut_toggled("the418-entity-scanner--toggle-interface", true)
end

--- @param data ScannerGuiData
function scanner_gui.close(data)
  if data.state.is_pinned then
    return
  end

  data.window.visible = false
  data.state.is_visible = false

  if data.player.opened == data.window then
    data.player.opened = nil
  end

  data.player.set_shortcut_toggled("the418-entity-scanner--toggle-interface", false)
end

--- @param data ScannerGuiData
function scanner_gui.destroy(data)
  local window = data.window
  if window and window.valid then
    if data.player.opened == window then
      data.player.opened = nil
    end

    data.window.destroy()
  end
  data.player_table.guis.scanner = nil
  data.player.set_shortcut_toggled("the418-entity-scanner--toggle-interface", false)
end

--- @param data ScannerGuiData
function scanner_gui.toggle(data)
  if data.state.is_visible then
    scanner_gui.close(data)
  else
    scanner_gui.open(data)
  end
end

--- @param data ScannerGuiData
function scanner_gui.toggle_pinned(data)
  data.state.is_pinned = not data.state.is_pinned
  updates.set_frame_action_button_active(data.elems.pin_button, "flib_pin", data.state.is_pinned)
end

-- HANDLERS

--- @param data ScannerGuiData
function scanner_gui.on_close(data)
  scanner_gui.close(data)
end

--- @param data ScannerGuiData
function scanner_gui.on_pin_click(data)
  scanner_gui.toggle_pinned(data)
end

--- @param data ScannerGuiData
--- @param event EventData.on_gui_elem_changed
function scanner_gui.on_filter_slot_changed(data, event)
  local entity_name = event.element.elem_value --[[@as string?]]
  local index = event.element.get_index_in_parent()

  if entity_name then
    data.player_table.entity_filters[index] = entity_name
  else
    table.remove(data.player_table.entity_filters, index)
  end

  updates.redraw_entity_filters(scanner_gui, data)
end

return scanner_gui
