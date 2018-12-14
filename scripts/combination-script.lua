local allowedPairs =
{
    ["steam-turbine"] = true,
    ["double-steam-turbine"] = true,
    ["steam-engine"] = true,
    ["double-steam-engine"] = true
}

local pairTable =
{
    ["steam-turbine"] = "double-steam-turbine",
    ["double-steam-turbine"] = "quad-steam-turbine",
    ["steam-engine"] = "double-steam-engine",
    ["double-steam-engine"] = "quad-steam-engine"
}

script.on_event(defines.events.on_built_entity, function(event)
    if allowedPairs[event.created_entity.name] then
        --game.print("It's allowed to pair!")
        checkForCombinations(event.created_entity, true, game.players[event.player_index])
    end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
    
    if allowedPairs[event.created_entity.name] then
        --game.print("It's allowed to pair!")
        checkForCombinations(event.created_entity, false, nil)
    end
end)

function checkForCombinations(entity, playerMade, player)
    local combine = false
    local combineNeighbor = nil
    --game.print("Checking for combinations!")
    for _, entities in pairs(entity.neighbours) do
        for _, neighbour in pairs(entities) do
            if neighbour.name == entity.name then
                combine = true
                combineNeighbor = neighbour
                break
            end
        end
        if combine == true then
            combineEntities(entity, combineNeighbor, playerMade, player)
        end
    end
end

function combineEntities(entity, combineNeighbor, playerMade, player)
    --game.print("Combined!")
    newTurbine = entity.surface.create_entity{
        name = pairTable[entity.name],
        position = {(entity.position.x + combineNeighbor.position.x)/2, (entity.position.y + combineNeighbor.position.y)/2},
        direction = entity.direction,
        force = entity.force,
        spill = false
    }
    entity.surface.create_entity{
        name = "flying-text",
        position = {(entity.position.x + combineNeighbor.position.x)/2, (entity.position.y + combineNeighbor.position.y)/2},
        text = "Combined!",
        color = { g = 1 }
    }
    if not entity.fluidbox[1] and not combineNeighbor.fluidbox[1] then
    elseif entity.fluidbox[1] and not combineNeighbor.fluidbox[1] then
        newTurbine.fluidbox[1] = entity.fluidbox[1]
    elseif not entity.fluidbox[1] and combineNeighbor.fluidbox[1] then
        newTurbine.fluidbox[1] = combineNeighbor.fluidbox[1]
    elseif entity.fluidbox[1] and combineNeighbor.fluidbox[1] then
        newTurbine.fluidbox[1] = {
            name = entity.fluidbox[1].name,
            amount = entity.fluidbox[1].amount + combineNeighbor.fluidbox[1].amount,
            temperature = ((entity.fluidbox[1].amount * entity.fluidbox[1].temperature) + (combineNeighbor.fluidbox[1].amount * combineNeighbor.fluidbox[1].temperature))/(entity.fluidbox[1].amount + combineNeighbor.fluidbox[1].amount)
        }
    end
    entity.destroy()
    combineNeighbor.destroy()
    if playerMade then
        script.raise_event(defines.events.on_built_entity, {player_index = player.index, created_entity = newTurbine})
    elseif not playerMade then
        script.raise_event(defines.events.on_robot_built_entity, {created_entity = newTurbine})
    end
end