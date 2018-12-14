local combine_name = {
  ['steam-turbine'] = true,
  ['steam-turbine-2'] = true,
  ['steam-turbine-3'] = true,
  ['steam-engine'] = true,
  ['steam-engine-2'] = true,
  ['steam-engine-3'] = true,
  ['steam-engine-4'] = true,
  ['steam-engine-5'] = true,
  ['steam-engine-mk2'] = true,
  ['steam-engine-mk3'] = true,
}

local function modify_box(box, multiplier)
  for _,corner in pairs(box) do
    local y = corner[2]
    y = multiplier == 2 and (y + (y/2)) or (y + (y*1.5))
    corner[2] = y
  end
  return box
end

local function modify_inputs(connections, box)
  local distance = math.abs(box[1][2])
  connections[1].position[2] = distance + 0.5
  connections[1].position[2] = -(distance + 0.5)
  return connections
end

local function build_horizontal_picture_layers(old_horizontal, multiplier)
  local old_h_layers = old_horizontal.layers
  local primary_h_sprite = old_h_layers[1]
  local primary_h_shadow = old_h_layers[1]

  if multiplier == 2 then
    horizontal
end

local function build_vertical_picture_layers(old_vertical, multiplier)
  local old_v_layers = old_vertical.layers
  local primary_v_sprite = old_v_layers[1]
  local primary_v_shadow = old_v_layers[1]

end
local modular_buildings = {}
for _, entity_data in pairs(data.raw.generator) do
  if combine_name[entity_data.name] and not entity_data.combined then
    for multiplier = 2, 4 do
      local new_entity = util.table.deepcopy(entity_data)
      local new_name = multipler == 2 and 'double-combined-' or 'quad-combined-'
      new_entity.combined = true
      new_entity.localised_name = {'modular.modular-name', new_entity.name, pipe_data.locale}
      new_entity.placeable_by = {
        item = new_entity.minable and new_entity.minable.result or new_entity.name,
        count = new_entity.minable and new_entity.minable.count and multiplier
      }
      new_entity.minable = {
        mining_time = multiplier * new_entity.minable.mining_time,
        result = new_entity.minable.result,
        count = multiplier
      }
      new_entity.fluid_usage_per_tick = new_entity.fluid_usage_per_tick * multiplier
      new_entity.max_health = new_entity.max_health * multiplier
      new_entity.collision_box = modify_box(new_entity.collision_box, multiplier)
      new_entity.selection_box = modify_box(new_entity.selection_box, multiplier)
      new_entity.fluid_box.base_area = new_entity.fluid_box.base_area * multiplier
      new_entity.fluid_box.pipe_connections = modify_inputs(new_entity.fluid_box.pipe_connections, new_entity.selection_box)
