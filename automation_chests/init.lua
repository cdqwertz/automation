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

	on_automation_rotate = function(pos, from, force)
		if force > 100 then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					local p = {	x = pos.x,
							y = pos.y + 1, 
							z = pos.z,
						  }
					minetest.spawn_item(p, stack)
					stack:clear()
					inv:set_stack("main", i, stack)
				end
			end
		elseif force > 10 then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					local p = {	x = pos.x,
							y = pos.y + 1, 
							z = pos.z,
						  }
					minetest.spawn_item(p, stack:take_item())
					inv:set_stack("main", i, stack)
					break
				end
			end
		end
	end
})

minetest.register_craft({
	output = 'automation_chests:metal_chest',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_materials:metal', '', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

local big_chest_formspec = "size[12,11]"
local big_chest_formspec = big_chest_formspec .. default.gui_bg
local big_chest_formspec = big_chest_formspec .. default.gui_bg_img
local big_chest_formspec = big_chest_formspec .. default.gui_slots
local big_chest_formspec = big_chest_formspec .. "list[current_name;main;0,0.3;12,6;]"
local big_chest_formspec = big_chest_formspec .. "list[current_player;main;2,6.85;8,1;]"
local big_chest_formspec = big_chest_formspec .. "list[current_player;main;2,8.08;8,3;8]"
local big_chest_formspec = big_chest_formspec .. "listring[current_name;main]"
local big_chest_formspec = big_chest_formspec .. "listring[current_player;main]"
local big_chest_formspec = big_chest_formspec .. default.get_hotbar_bg(2,6.85)

minetest.register_node("automation_chests:strong_metal_chest", {
	description = "Strong Metal Chest",
	tiles = {"automation_strong_metal.png", "automation_strong_metal.png", "automation_strong_metal_chest.png"},
	groups = {cracky = 1},
	sounds =  default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", big_chest_formspec)
		local inv = meta:get_inventory()
		inv:set_size("main", 12*6)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_automation_rotate = function(pos, from, force)
		if force > 200 then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					local p = {	x = pos.x,
							y = pos.y + 1, 
							z = pos.z,
						  }
					minetest.spawn_item(p, stack)
					stack:clear()
					inv:set_stack("main", i, stack)
				end
			end
		elseif force > 10 then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", i)
				if not stack:is_empty() then
					local p = {	x = pos.x,
							y = pos.y + 1, 
							z = pos.z,
						  }
					minetest.spawn_item(p, stack:take_item())
					inv:set_stack("main", i, stack)
					break
				end
			end
		end
	end
})

minetest.register_craft({
	output = 'automation_chests:strong_metal_chest',
	recipe = {
		{'automation_materials:strong_metal', 'automation_materials:strong_metal', 'automation_materials:strong_metal'},
		{'automation_materials:strong_metal', '', 'automation_materials:strong_metal'},
		{'automation_materials:strong_metal', 'automation_materials:strong_metal', 'automation_materials:strong_metal'},
	}
})
