local player_gui = require("__the418_entity_scanner__/scripts/player-gui")

local migrations = {}

function migrations.generic()
  for i, player_table in pairs(global.players) do
    local player = game.get_player(i)
    if player then
      player_gui.refresh(player, player_table)
    end
  end
end

return migrations
