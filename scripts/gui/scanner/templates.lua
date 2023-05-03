local table = require("__flib__/table")

local constants = require("__the418_entity_scanner__/constants")

local templates = {}

--- @class ScannerGuiElems
--- @field the418_entity_scanner__scanner_window LuaGuiElement
--- @field titlebar_flow LuaGuiElement
--- @field pin_button LuaGuiElement
--- @field filter_slot_container LuaGuiElement
--- @field filter_slot_table LuaGuiElement
--- @field empty_filter_slot LuaGuiElement

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @return ScannerGuiElems
function templates.render(gui, data)
  return {
    type = "frame",
    name = "the418_entity_scanner__scanner_window",
    style_mods = { width = constants.gui.scanner.width, height = constants.gui.scanner.height },
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
      drag_target = "the418_entity_scanner__scanner_window",
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
        style = "inside_shallow_frame_with_padding",
        direction = "vertical",
        {
          type = "frame",
          name = "filter_slot_container",
          direction = "vertical",
          style = "filter_scroll_pane_background_frame",
          style_mods = {
            horizontally_stretchable = "on",
            vertically_stretchable = "on",
            width = 200,
          },
          {
            type = "table",
            name = "filter_slot_table",
            style = "filter_slot_table",
            column_count = 10,
            table.unpack(templates.entity_filter_slot_buttons(gui, data)),
          },
        },
      },
    },
  }
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @return LuaGuiElement[]
function templates.entity_filter_slot_buttons(gui, data)
  local buttons = {}

  for _, entity_name in pairs(data.player_table.entity_filters) do
    table.insert(buttons, templates.entity_filter_slot_button(gui, data, entity_name))
  end

  table.insert(buttons, templates.entity_filter_slot_button(gui, data))

  return buttons
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @param entity_name string?
--- @return LuaGuiElement
function templates.entity_filter_slot_button(gui, data, entity_name)
  local used_entity_names = data.player_table.entity_filters
  local filtered_entity_names = entity_name
      and table.filter(used_entity_names, function(name)
        return name ~= entity_name
      end, true)
    or used_entity_names

  return {
    type = "choose-elem-button",
    style = "slot_button",
    elem_type = "entity",
    elem_value = entity_name,
    entity = entity_name or nil,
    elem_filters = { { filter = "name", name = filtered_entity_names, invert = true } },
    handler = {
      [defines.events.on_gui_elem_changed] = gui.on_filter_slot_changed,
    },
  }
end

return templates
