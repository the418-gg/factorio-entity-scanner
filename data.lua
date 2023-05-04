data:extend({
  {
    type = "custom-input",
    name = "the418-entity-scanner--toggle-interface",
    key_sequence = "",
    order = "a",
  },
  {
    type = "shortcut",
    name = "the418-entity-scanner--toggle-interface",
    icon = { filename = "__base__/graphics/icons/radar.png", size = 64, mipmap_count = 2 },
    toggleable = true,
    associated_control_input = "the418-entity-scanner--toggle-interface",
    action = "lua",
  },
})

local styles = data.raw["gui-style"].default

styles.the418_entity_scanner__red_dialog_button = {
  type = "button_style",
  parent = "dialog_button",
  default_graphical_set = styles.red_button.default_graphical_set,
  hovered_graphical_set = styles.red_button.hovered_graphical_set,
  clicked_graphical_set = styles.red_button.clicked_graphical_set,
}

styles.the418_entity_scanner__green_dialog_button = {
  type = "button_style",
  parent = "dialog_button",
  default_graphical_set = styles.green_button.default_graphical_set,
  hovered_graphical_set = styles.green_button.hovered_graphical_set,
  clicked_graphical_set = styles.green_button.clicked_graphical_set,
}

styles.the418_entity_scanner__scroll_pane = {
  type = "scroll_pane_style",
  parent = "list_box_scroll_pane",
  horizontally_stretchable = "stretch_and_expand",
  vertically_stretchable = "stretch_and_expand",
  padding = 0,
  vertical_flow_style = {
    type = "vertical_flow_style",
    vertical_spacing = 2,
  },
}
