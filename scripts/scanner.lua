local on_tick_n = require("__flib__/on-tick-n")

local constants = require("__the418_entity_scanner__/constants")

local scanner = {}

--- @param task ScannerTask
local function enqueue_task(task)
  local task_id = on_tick_n.add(game.tick + constants.scanner.task_interval, task)
  scanner.update_scan_status(task, task_id)
end

--- @param player LuaPlayer
--- @param entity_names string[]
function scanner.begin_scan(player, entity_names)
  --- @type ScannerTask
  local task = {
    type = "scan",
    player_index = player.index,
    entity_names = entity_names,
    current_surface_index = 1,
    current_surface_chunk_areas = {},
    current_chunk_index = 1,
    results = {
      surfaces = {},
      started_at = game.tick,
      finished_at = game.tick,
      entity_names = entity_names,
    },
    entities_found = 0,
    is_done = false,
  }
  enqueue_task(task)
end

--- @param task ScannerTask
function scanner.perform(task)
  if task.is_done then
    -- TODO
  else
    local new_task = scanner.perform_scan_step(task)
    enqueue_task(new_task)
  end
end

--- @param task_id TaskIdent
function scanner.stop(task_id)
  on_tick_n.remove(task_id)
end

--- @package
--- @param task ScannerTask
--- @return ScannerTask
function scanner.perform_scan_step(task)
  local surface = game.get_surface(task.current_surface_index)
  if not surface then
    task.is_done = true
    task.finished_at = game.tick
    return task
  end
  if not task.results.surfaces[surface.index] then
    task.results.surfaces[surface.index] = {}
  end

  if #task.current_surface_chunk_areas == 0 then
    -- Calculate available chunk areas
    for chunk in surface.get_chunks() do
      if
        surface.is_chunk_generated(chunk --[[@as ChunkPosition]])
      then
        table.insert(task.current_surface_chunk_areas, chunk.area)
      end
    end

    if #task.current_surface_chunk_areas == 0 then
      -- If surface is still empty, go to a new surface
      task.current_surface_index = task.current_surface_index + 1
      task.current_surface_chunk_areas = {}
      task.current_chunk_index = 1
      return task
    end

    return task
  end

  for i = 1, constants.scanner.chunks_per_task do
    local area = task.current_surface_chunk_areas[task.current_chunk_index + i - 1]
    if not area then
      -- This surface has been covered, go to the next one
      task.current_surface_index = task.current_surface_index + 1
      task.current_surface_chunk_areas = {}
      task.current_chunk_index = 1
      return task
    end

    local entities = surface.find_entities_filtered({ area = area, name = task.entity_names })
    for _, entity in pairs(entities) do
      table.insert(
        task.results.surfaces[task.current_surface_index],
        { entity_name = entity.name, map_position = entity.position }
      )
      task.entities_found = task.entities_found + 1
    end
  end
  task.current_chunk_index = task.current_chunk_index + constants.scanner.chunks_per_task

  return task
end

--- @package
--- @param task ScannerTask
--- @param task_id TaskIdent
function scanner.update_scan_status(task, task_id)
  local surface = game.get_surface(task.current_surface_index)

  --- @type ScanStatus
  local status = {
    task_id = task_id,
    status = task.is_done and "done" or "in_progress",
    surface_name = surface and surface.name or nil,
    entities_found = task.entities_found,
    scan_duration = game.tick - task.results.started_at,
    results = task.results,
  }

  global.players[task.player_index].scan_status = status
end

--- @class ScanResultEntity
--- @field entity_name string
--- @field map_position MapPosition

--- @alias ScanResultSurfaces table<uint, ScanResultEntity[]>

--- @class ScanResults
--- @field surfaces ScanResultSurfaces
--- @field started_at uint
--- @field finished_at uint
--- @field entity_names string[]

--- @class ScannerTask
--- @field type "scan"
--- @field player_index uint
--- @field entity_names string[]
--- @field current_surface_index uint
--- @field current_surface_chunk_areas BoundingBox[]
--- @field current_chunk_index uint
--- @field results ScanResults
--- @field entities_found uint
--- @field is_done boolean

--- @class ScanStatus
--- @field task_id TaskIdent?
--- @field status "not_started" | "in_progress" | "done"
--- @field surface_name string?
--- @field entities_found integer
--- @field scan_duration uint
--- @field results ScanResults?

return scanner
