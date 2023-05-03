local gui = require("__flib__/gui-lite")
local on_tick_n = require("__flib__/on-tick-n")

local player_data = require("__the418_entity_scanner__/scripts/player-data")
local player_gui = require("__the418_entity_scanner__/scripts/player-gui")
local migrations = require("__the418_entity_scanner__/scripts/migrations")

script.on_init(function()
  on_tick_n.init()

  -- Array of entity names
  --- @type string[]
  global.filters = {}
  --- @type table<uint, PlayerTable>
  global.players = {}

  for _, player in pairs(game.players) do
    player_data.init(player)
  end
  migrations.generic()
end)

script.on_load(function()
  for _, player_table in pairs(global.players) do
    player_data.load(player_table)
  end
end)

script.on_configuration_changed(function(event)
  if event.migration_applied then
    migrations.generic()
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index) --[[@as LuaPlayer]]
  player_data.init(player)
  player_data.refresh(player, global.players[event.player_index])
end)

script.on_event(defines.events.on_player_removed, function(event)
  global.players[event.player_index] = nil
end)

script.on_event(defines.events.on_tick, function(event)
  local tasks = on_tick_n.retrieve(event.tick)

  if tasks then
    for _, task in pairs(tasks) do
      -- TODO
    end
  end
end)

script.on_event("the418-entity-scanner--toggle-interface", function(event)
  player_gui.toggle_interface(event.player_index)
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == "the418-entity-scanner--toggle-interface" then
    player_gui.toggle_interface(event.player_index)
  end
end)

player_gui.register_handlers()
gui.handle_events()
