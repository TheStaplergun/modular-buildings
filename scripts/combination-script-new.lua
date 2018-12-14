-------------------------------------------------------------------------------
--[[Building Combiner]] --
-------------------------------------------------------------------------------
-- Concept designed and code written by TheStaplergun (staplergun on mod portal)
-- STDLib provided by Nexela

local Player = require('lib/player')
local Event = require('lib/event')
local Position = require('lib/position')

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

local function average_temperature(e_f_a, e_f_t, n_f_a, n_f_t)
    return ((e_f_a * e_f_t)+ (n_f_a * n_f_t))/(e_f_a + n_f_a)
end
local function combine_entity(entity, neighbour, player_index)
    --local player, pdata = player_index and Player.get(player_index)
    local entity_name = entity.name
    local entity_position = entity.position
    --local neighbour_name = neighbour.name
    local neighbour_position = neighbour.position
    local center_point = Position.average(entity_position, neighbour_position)
    local combined_entity
    if string.find(entity_name, "^double%-combined%-") then
        if not string.find(entity_name, "^quad%-combined%-") then
            combined_entity = entity.surface.create_entity({
                name = "quad-combined-" .. entity_name,
                position = center_point,
                direction = entity.direction,
                force = entity.force,
                spill = false
            })
        end
    else
        combined_entity = entity.surface.create_entity({
            name = "double-combined-" .. entity_name,
            position = center_point,
            direction = entity.direction,
            force = entity.force,
            spill = false
        })
    end
    local entity_fluidbox = entity.fluidbox and entity.fluidbox[1]
    local neighbour_fluidbox = neighbour.fluidbox and neighbour.fluidbox[1]
    if entity_fluidbox then
        local e_fluidbox_temp = entity_fluidbox.temperature
        local e_fluidbox_amt = entity_fluidbox.amount
        if neighbour_fluidbox then
            local n_fluidbox_temp = neighbour_fluidbox.temperature
            local n_fluidbox_amt = neighbour_fluidbox.amount
            combined_entity.fluidbox[1] = {
                name = entity_fluidbox.name,
                amount = e_fluidbox_amt + n_fluidbox_amt,
                temperature = average_temperature(e_fluidbox_amt, e_fluidbox_temp, n_fluidbox_amt, n_fluidbox_temp)
            }
        else
            combined_entity.fluidbox[1] = entity_fluidbox
        end
    else
        if neighbour_fluidbox then
            combined_entity.fluidbox[1] = neighbour_fluidbox
        end
    end
    entity.surface.create_entity{
        name = "flying-text",
        position = center_point,
        text = {'modular.combined'},
        color = { g = 1 }
    }
    if entity then
        entity.destroy()
    end
    if neighbour then
        neighbour.destroy()
    end
    if player_index then
        script.raise_event(defines.events.on_built_entity, {player_index = player_index, created_entity = combined_entity})
    else
        script.raise_event(defines.events.on_robot_built_entity, {created_entity = combined_entity})
    end
end

local function check_for_combination(event)
    local entity = event.created_entity
    local entity_name = entity.name
    local entity_type = entity.type
    game.print("Event fired")
    if combine_name[entity_name] then
        game.print("It's an allowed type")
        if string.find(entity_name, "^double%-combined%-") or not string.find(entity_name, "^quad%-combined%-") then
            for _, entities in pairs(entity.neighbours) do
                for _, neighbour in pairs(entities) do
                    if neighbour.name == entity_name then
                        combine_entity(entity, neighbour, event.name == 'on_built_entity' and event.player_index)
                        break
                    end
                end
            end
        end
    end
end
Event.register({defines.events.on_built_entity,defines.events.on_robot_built_entity}, check_for_combination)
