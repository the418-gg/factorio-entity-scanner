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

return updates
