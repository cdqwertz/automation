local chest_formspec = "size[8,11]"
local chest_formspec = chest_formspec .. default.gui_bg
local chest_formspec = chest_formspec .. default.gui_bg_img
local chest_formspec = chest_formspec .. default.gui_slots
local chest_formspec = chest_formspec .. "list[current_name;main;0,0.3;8,6;]"
local chest_formspec = chest_formspec .. "list[current_player;main;0,6.85;8,1;]"
local chest_formspec = chest_formspec .. "list[current_player;main;0,8.08;8,3;8]"
local chest_formspec = chest_formspec .. "listring[current_name;main]"
local chest_formspec = chest_formspec .. "listring[current_player;main]"
local chest_formspec = chest_formspec .. default.get_hotbar_bg(0,6.85)

minetest.register_node("automation_chests:metal_chest", {
	description = "Metal Chest",
	tiles = {"automation_metal.png", "automation_metal.png", "automation_chest.png"},
	groups = {cracky = 2},
	sounds =  default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", chest_formspec)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*6)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_craft({
	output = 'automation_chests:metal_chest',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_materials:metal', '', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

