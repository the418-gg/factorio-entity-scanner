local player_data = require("__the418_entity_scanner__/scripts/player-data")

local migrations = {}

function migrations.generic()
  for i, player_table in pairs(global.players) do
    local player = game.get_player(i)
    if player then
      player_data.refresh(player, player_table)
    end
  end
end

return migrations
