local format = require("__flib__/format")
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
--- @field scan_status_container LuaGuiElement
--- @field action_button LuaGuiElement
--- @field results LuaGuiElement

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
          type = "flow",
          direction = "vertical",
          {
            type = "label",
            style = "heading_3_label",
            caption = { "gui.the418-entity-scanner--scanner-caption-entities" },
          },
          {
            type = "scroll-pane",
            style = "scroll_pane_in_shallow_frame",
            direction = "vertical",
            style_mods = {
              padding = 0,
              extra_padding_when_activated = 0,
              vertically_stretchable = "off",
              height = 120,
            },
            {
              type = "frame",
              name = "filter_slot_container",
              direction = "vertical",
              style = "filter_scroll_pane_background_frame",
              style_mods = {
                horizontally_stretchable = "on",
                vertically_stretchable = "on",
              },
              {
                type = "table",
                name = "filter_slot_table",
                style = "filter_slot_table",
                column_count = 6,
                table.unpack(templates.entity_filter_slot_buttons(gui, data)),
              },
            },
          },
          {
            type = "flow",
            name = "scan_status_container",
            templates.scan_status(gui, data),
          },
          {
            type = "empty-widget",
            style = "flib_vertical_pusher",
          },
          {
            type = "label",
            style = "heading_3_label",
            caption = { "gui.the418-entity-scanner--scanner-caption-results" },
            table.unpack(templates.scan_results(gui, data)),
          },
          {
            type = "scroll-pane",
            name = "results",
            style = "the418_entity_scanner__scroll_pane",
            direction = "vertical",
          },
        },
      },
    },
    {
      type = "flow",
      style = "dialog_buttons_horizontal_flow",
      drag_target = "the418_entity_scanner__scanner_window",
      {
        type = "empty-widget",
        style = "flib_dialog_footer_drag_handle",
        ignored_by_interaction = true,
      },
      {
        type = "button",
        name = "action_button",
        style = "the418_entity_scanner__green_dialog_button",
        caption = { "gui.the418-entity-scanner--scanner-button-scan-on" },
        handler = {
          [defines.events.on_gui_click] = gui.on_scan_click,
        },
      },
      {
        type = "empty-widget",
        style = "flib_dialog_footer_drag_handle",
        ignored_by_interaction = true,
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
    enabled = data.player_table.scan_status.status ~= "in_progress",
    handler = {
      [defines.events.on_gui_elem_changed] = gui.on_filter_slot_changed,
    },
  }
end

local status_indicators = {
  not_started = "black",
  in_progress = "yellow",
  done = "green",
}

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @return LuaGuiElement
function templates.scan_status(gui, data)
  local scan_status = data.player_table.scan_status

  return {
    type = "flow",
    direction = "vertical",
    templates.scan_status_row({ "gui.the418-entity-scanner--scanner-caption-status" }, {
      {
        type = "sprite",
        style = "flib_indicator",
        sprite = "flib_indicator_" .. status_indicators[scan_status.status],
      },
      {
        type = "label",
        caption = { "gui.the418-entity-scanner--scanner-status-" .. scan_status.status },
      },
    }),
    templates.scan_status_row({ "gui.the418-entity-scanner--scanner-caption-surface" }, {
      {
        type = "label",
        caption = scan_status.surface_name or "",
      },
    }),
    templates.scan_status_row({ "gui.the418-entity-scanner--scanner-caption-entities-found" }, {
      {
        type = "label",
        caption = scan_status.entities_found,
      },
    }),
    templates.scan_status_row({ "gui.the418-entity-scanner--scanner-caption-duration" }, {
      {
        type = "label",
        caption = format.time(scan_status.scan_duration),
      },
    }),
  }
end

--- @package
--- @param label LocalisedString
--- @param children LuaGuiElement[]
--- @return LuaGuiElement
function templates.scan_status_row(label, children)
  return {
    type = "flow",
    direction = "horizontal",
    style_mods = { vertical_align = "center" },
    {
      type = "label",
      caption = label,
    },
    {
      type = "empty-widget",
      style = "flib_horizontal_pusher",
    },
    table.unpack(children),
  }
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @return LuaGuiElement[]
function templates.scan_results(gui, data)
  local elems = {}

  local scan_results = data.player_table.scan_status.results
  if not scan_results then
    return elems
  end

  for surface_idx, surface in pairs(scan_results.surfaces) do
    for entity_idx, entity in pairs(surface) do
      table.insert(elems, templates.scan_result(gui, data, entity, surface_idx, entity_idx))
    end
  end

  return elems
end

--- @param gui ScannerGui
--- @param data ScannerGuiData
--- @param entity ScanResultEntity
--- @param surface_index number
--- @param entity_index number
function templates.scan_result(gui, data, entity, surface_index, entity_index)
  return {
    type = "button",
    style_mods = {
      horizontally_stretchable = "on",
      horizontally_squashable = "on",
    },
    caption = "[entity=" .. entity.entity_name .. "]",
    tags = {
      the418_entity_scanner = {
        surface_index = surface_index,
        entity_index = entity_index,
      },
    },
    handler = {
      [defines.events.on_gui_click] = gui.on_result_click,
    },
  }
end

return templates
