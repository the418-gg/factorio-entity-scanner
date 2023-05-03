local constants = require("__the418_entity_scanner__/constants")
local gui = require("__the418_entity_scanner__/scripts/gui/scanner/gui")

local templates = {}

--- @class ScannerGuiElems
--- @field the418_entity_scanner__scanner_window LuaGuiElement
--- @field titlebar_flow LuaGuiElement
--- @field pin_button LuaGuiElement

--- @return ScannerGuiElems
function templates.render()
  return {
    type = "frame",
    name = "the418_entity_scanner__scanner_window",
    style_mods = { height = constants.gui.scanner.height },
    direction = "vertical",
    ref = { "window" },
    visible = false,
    elem_mods = { auto_center = true },
    handler = {
      [defines.events.on_gui_closed] = gui.on_close,
    },
    {
      type = "flow",
      name = "titlebar_flow",
      style = "flib_titlebar_flow",
      style_mods = {
        horizontal_spacing = 8,
      },
      {
        type = "label",
        style = "frame_title",
        caption = { "gui.the418-entity-scanner--scanner-title" },
        ignored_by_interaction = true,
      },
      {
        type = "empty-widget",
        style = "flib_titlebar_drag_handle",
        ignored_by_interaction = true,
      },
      {
        type = "sprite-button",
        name = "pin_button",
        tooltip = { "gui.flib-keep-open" },
        style = "frame_action_button",
        sprite = "flib_pin_white",
        hovered_sprite = "flib_pin_black",
        clicked_sprite = "flib_pin_black",
        handler = {
          [defines.events.on_gui_click] = gui.on_pin_click,
        },
      },
      {
        type = "sprite-button",
        tooltip = { "gui.close" },
        style = "frame_action_button",
        sprite = "utility/close_white",
        hovered_sprite = "utility/close_black",
        clicked_sprite = "utility/close_black",
        handler = {
          [defines.events.on_gui_click] = gui.on_close,
        },
      },
    },
    {
      type = "flow",
      direction = "horizontal",
      {
        type = "frame",
        style = "inside_shallow_frame",
        direction = "vertical",
      },
    },
  }
end

return templates
