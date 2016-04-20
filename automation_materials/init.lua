-- blocks

minetest.register_node("automation_materials:metal_block", {
	description = "Metal Block",
	tiles = {"automation_metal.png"},
	groups = {choppy = 1},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_node("automation_materials:glass", {
	description = "Framed Glass",
	tiles = {"automation_glass.png"},
	drawtype = "glasslike",
	paramtype = "light",
	groups = {choppy = 3},
	sounds =  default.node_sound_glass_defaults(),
})

-- items
minetest.register_craftitem("automation_materials:metal", {
	description = "Metal",
	inventory_image = "automation_metal.png",
})

-- crafts

minetest.register_craft({
	output = 'automation_materials:metal',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'automation_materials:metal_block',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

minetest.register_craft({
	output = 'automation_materials:glass',
	type = 'cooking',
	recipe = 'automation_materials:metal',
})
