data:extend(
{
  --Turbines
  {
    type = "item",
    name = "double-steam-turbine",
    icon = "__base__/graphics/icons/steam-turbine.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "b[steam-power]-c[steam-turbine]",
    place_result = "double-steam-turbine",
    stack_size = 10
  },
  {
    type = "item",
    name = "quad-steam-turbine",
    icon = "__base__/graphics/icons/steam-turbine.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "b[steam-power]-c[steam-turbine]",
    place_result = "quad-steam-turbine",
    stack_size = 10
  },


  --Engines
  {
    type = "item",
    name = "double-steam-engine",
    icon = "__base__/graphics/icons/steam-engine.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "b[steam-power]-b[steam-engine]",
    place_result = "double-steam-engine",
    stack_size = 10
  },
  {
    type = "item",
    name = "quad-steam-engine",
    icon = "__base__/graphics/icons/steam-engine.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "b[steam-power]-b[steam-engine]",
    place_result = "quad-steam-engine",
    stack_size = 10
  },
}
)
