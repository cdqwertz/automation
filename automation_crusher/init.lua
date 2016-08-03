automation_crusher = {}

automation_crusher.crafts = {}

function automation_crusher.register_dust(def)
	minetest.register_craftitem(def.name, {
		description = def.description,
		inventory_image = def.img,
	})

	automation_crusher.crafts[#automation_crusher.crafts+1] = {output = def.name .. " 2", input = def.material}

	minetest.register_craft({
		type = "cooking",
		output = def.ingot,
		recipe = def.name,
	})
end


automation_crusher.register_dust({
	name = "automation_crusher:dust_gold",
	description = "Gold Dust",
	img = "automation_dust_gold.png",
	material = "default:gold_lump",

	ingot = "default:gold_ingot",
})

automation_crusher.register_dust({
	name = "automation_crusher:dust_iron",
	description = "Iron Dust",
	img = "automation_dust_iron.png",
	material = "default:iron_lump",
	
	ingot = "default:steel_ingot"
})


local crusher_formspec = "size[8,8]"
local crusher_formspec = crusher_formspec .. default.gui_bg
local crusher_formspec = crusher_formspec .. default.gui_bg_img
local crusher_formspec = crusher_formspec .. default.gui_slots

local crusher_formspec = crusher_formspec .. "list[current_name;main;1,1;2,2;]"
local crusher_formspec = crusher_formspec .. "list[current_name;output;5,1;2,2;]"
local crusher_formspec = crusher_formspec .. "image[3.5,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]]"

local crusher_formspec = crusher_formspec .. "list[current_player;main;0,3.85;8,1;]"
local crusher_formspec = crusher_formspec .. "list[current_player;main;0,5.08;8,3;8]"

local crusher_formspec = crusher_formspec .. "listring[current_name;main]"
local crusher_formspec = crusher_formspec .. "listring[current_name;output]"
local crusher_formspec = crusher_formspec .. "listring[current_player;main]"
--local crusher_formspec = crusher_formspec .. "listring[current_player;main]"

local crusher_formspec = crusher_formspec .. default.get_hotbar_bg(0,3.85)

minetest.register_node("automation_crusher:crusher", {
	description = "Crusher",
	tiles = {"automation_crusher_top.png", "automation_strong_metal.png", "automation_crusher_side.png"},
	groups = {cracky = 1},
	sounds =  default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", crusher_formspec)
		local inv = meta:get_inventory()
		inv:set_size("main", 2*2)
		inv:set_size("output", 2*2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and inv:is_empty("output")
	end,

	on_automation_rotate = function(pos, from, force)
		if force > 200 then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			
			for i=1,#automation_crusher.crafts do
				if inv:contains_item("main", automation_crusher.crafts[i].input) then
					inv:remove_item("main", automation_crusher.crafts[i].input)
					inv:add_item("output", automation_crusher.crafts[i].output)

					break
				end
			end
		end
	end
})

minetest.register_craft({
	output = 'automation_crusher:crusher',
	recipe = {
		{'automation_materials:strong_metal', 'automation_pistons:piston', 'automation_materials:strong_metal'},
		{'automation_materials:strong_metal', 'default:flint', 'automation_materials:strong_metal'},
		{'automation_materials:strong_metal', '', 'automation_materials:strong_metal'},
	}
})
