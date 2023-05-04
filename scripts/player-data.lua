local player_data = {}

--- @param player LuaPlayer
function player_data.init(player)
  --- @class PlayerTable
  global.players[player.index] = {
    --- @type PlayerGuis
    guis = {},
    --- @type string[]
    entity_filters = {},
    --- @type ScanStatus
    scan_status = {
      task_id = nil,
      status = "not_started",
      surface_name = nil,
      entities_found = 0,
      scan_duration = 0,
      results = nil,
    },
  }
end

--- @param player LuaPlayer
--- @param index uint
--- @param entity_name string
function player_data.set_entity_filter(player, index, entity_name)
  global.players[player.index].entity_filters[index] = entity_name
end

--- @class PlayerGuis
--- @field scanner ScannerGuiData

return player_data
