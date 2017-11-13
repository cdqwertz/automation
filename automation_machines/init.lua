local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local inv_formspec = "size[8,9]"
local inv_formspec = inv_formspec .. default.gui_bg
local inv_formspec = inv_formspec .. default.gui_bg_img
local inv_formspec = inv_formspec .. default.gui_slots
local inv_formspec = inv_formspec .. "list[current_name;main;0,0.3;8,4;]"
local inv_formspec = inv_formspec .. "list[current_player;main;0,4.85;8,1;]"
local inv_formspec = inv_formspec .. "list[current_player;main;0,6.08;8,3;8]"
local inv_formspec = inv_formspec .. "listring[current_name;main]"
local inv_formspec = inv_formspec .. "listring[current_player;main]"
local inv_formspec = inv_formspec .. default.get_hotbar_bg(0,4.85)

-- machines

minetest.register_node("automation_machines:quarry", {
	description = "Quarry",
	tiles = {"automation_metal.png", "automation_metal.png", "automation_quarry.png"},
	groups = {choppy = 3, machine=1},
	sounds =  default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", inv_formspec)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	on_automation_rotate = function(pos, from, force)
		if force > 200 then
			local meta = minetest.get_meta(pos)
			local deep = meta:get_int("deep") +1
			if deep < force*2-200 then
				local p = {x=pos.x, y=pos.y-deep, z=pos.z}
				local n = minetest.get_node(p).name
				local def = minetest.registered_nodes[n]
				meta:get_inventory():add_item("main", def.drop or n)
				minetest.set_node(p, {name = "air"})
				meta:set_int("deep", deep)
			end
		end
	end,
})

minetest.register_craft({
	output = 'automation_machines:quarry',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_machines:axle', 'automation_machines:spring', 'default:pick_mese'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

minetest.register_node("automation_machines:harvester", {
	description = "Harvester",
	tiles = {"automation_harvester.png", "automation_metal.png"},
	groups = {choppy = 3, machine=1},
	sounds =  default.node_sound_stone_defaults(),
	on_automation_rotate = function(pos, from, force)
		if force > 100 then
			for dx = -1, 1 do
				for dz = -1, 1 do
					if not (dx == 0 and dz == 0) then
						local p = {x = pos.x+dx, y=pos.y, z = pos.z+dz}
						local n = minetest.get_node(p).name
						if n == "air" then
							minetest.set_node(p, {name = "default:sapling"})
						else
						end
					end
				end
			end

			for kx = -5, 5 do
				for ky = 0, 5 do
					for kz = -5, 5 do
						local k = {x = pos.x+kx, y=pos.y+ky, z = pos.z+kz}
						local n = minetest.get_node(k).name
						if n and n== "default:tree" then
							minetest.set_node(k, {name = "air"})
						end
					end
				end
			end

		end
	end,
})

minetest.register_node("automation_machines:crank", {
	description = "Crank",
	tiles = {"automation_metal.png"},
	groups = {choppy = 3},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.1, -0.1, 0, 0.1, 0.1, 0.5},
				{-0.2, -0.2, -0.1, 0.2, 0.2, 0},
			},
	},
	on_punch = function(pos, player, pt)
		local dir = minetest.facedir_to_dir(minetest.get_node({x = pos.x, y= pos.y, z=pos.z}).param2)
		local next_pos = vector.add(pos, dir)
		local node = minetest.registered_nodes[minetest.get_node(next_pos).name]

		if node and node.on_automation_rotate then
			node.on_automation_rotate(next_pos, pos, 50)
		end
	end,
})

minetest.register_craft({
	output = 'automation_machines:crank',
	recipe = {
		{'default:steel_ingot', '', ''},
		{'default:steel_ingot', 'automation_machines:axle', 'automation_machines:axle'},
		{'default:steel_ingot', '', ''},
	}
})

minetest.register_node("automation_machines:spring", {
	description = "Spring",
	tiles = {"automation_metal.png"},
	groups = {choppy = 3, spring = 1},
	sounds =  default.node_sound_glass_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.2, -0.2, -0.5, 0.2, 0.2, 0.5},
			},
	},
	on_automation_rotate = function(pos, from, force)
		print("[automation] rotate spring")
		local meta = minetest.get_meta(pos)
		local f = meta:get_int("force") + force
		if f > 200 then
			local dir = vector.multiply(vector.subtract(from,pos), -1)
			local next_pos = vector.add(pos, dir)
			print(minetest.pos_to_string(next_pos))
			local node = minetest.registered_nodes[minetest.get_node(next_pos).name]

			if node and node.on_automation_rotate then
				node.on_automation_rotate(next_pos, pos, f)
				print("[automation] spring rotate")
				f = 0
			end
		end
		meta:set_int("force", f)
	end,
})

minetest.register_craft({
	output = 'automation_machines:spring',
	recipe = {
		{'automation_machines:axle', 'automation_machines:axle', 'automation_machines:axle'},
	}
})

-- generators

minetest.register_node("automation_machines:boiler_empty", {
	description = "Boiler",
	tiles = {"automation_boiler_top.png", "automation_boiler_top.png", "automation_boiler_side_empty.png"},
	groups = {choppy = 3, connects_to_pipe = 1},
	sounds =  default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("water", 0)
		meta:set_string("infotext", "Water : 0")
	end,

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 1 then
			swap_node(pos, "automation_machines:boiler")

			local meta = minetest.get_meta(pos)
			meta:set_int("water", 100)
			meta:set_string("infotext", "Water : 100")
		end
	end,

	on_punch = function(pos, node, puncher, pointed_thing)
		local wielded_item = puncher:get_wielded_item():get_name()
		if wielded_item == "bucket:bucket_water" then
			swap_node(pos, "automation_machines:boiler")

			local meta = minetest.get_meta(pos)
			meta:set_int("water", 100)
			meta:set_string("infotext", "Water : 100")

			local w = puncher:get_wielded_item()
			w:take_item(1)
			puncher:set_wielded_item(w)
			puncher:get_inventory():add_item("main", "bucket:bucket_empty")
		end
	end
})

minetest.register_craft({
	output = 'automation_machines:boiler_empty',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_materials:glass', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

minetest.register_node("automation_machines:boiler", {
	description = "Boiler",
	tiles = {"automation_boiler_top.png", "automation_boiler_top.png", "automation_boiler_side.png"},
	groups = {choppy = 3,connects_to_pipe = 1},
	sounds =  default.node_sound_stone_defaults(),

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 1 then
			local meta = minetest.get_meta(pos)
			meta:set_int("water", 100)
			meta:set_string("infotext", "Water : 100")
		end
	end,

	drop = "automation_machines:boiler_empty",
})

minetest.register_node("automation_machines:boiler_active", {
	description = "Boiler",
	tiles = {"automation_boiler_top.png", "automation_boiler_top.png", "automation_boiler_side_active.png"},
	groups = {choppy = 3, connects_to_pipe = 1},
	sounds =  default.node_sound_stone_defaults(),

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 1 then
			local meta = minetest.get_meta(pos)
			meta:set_int("water", 100)
			meta:set_string("infotext", "Water : 100")
		end
	end,

	drop = "automation_machines:boiler_empty",
})

minetest.register_abm({
	nodenames = {"automation_machines:boiler"},
	neighbors = {"group:lava"},
	interval = 5.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		swap_node(pos, "automation_machines:boiler_active")
	end,
})


minetest.register_node("automation_machines:steam_engine", {
	description = "Steam Engine",
	tiles = {"automation_metal.png", "automation_metal.png", "automation_steam_engine.png"},
	groups = {choppy = 3, machine=1},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = 'automation_machines:steam_engine',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_pipes:pipe', 'automation_pistons:piston', 'automation_machines:axle'},
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
	}
})

minetest.register_abm({
	nodenames = {"automation_machines:steam_engine"},
	neighbors = {"automation_machines:boiler_active"},
	interval = 5.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for dx = -1, 1 do
			for dy = -1, 1 do
				for dz = -1, 1 do
					if not (dx == 0 and dz == 0) then
						local p = {x = pos.x+dx, y=pos.y+dy, z = pos.z+dz}
						local n = minetest.get_node(p).name
						if n and n== "automation_machines:boiler_active" then
							local meta = minetest.get_meta(p)
							meta:set_int("water", meta:get_int("water")-10)
							meta:set_string("infotext", "Water : " .. tostring(meta:get_int("water")))
							if meta:get_int("water") < 1 then
								minetest.set_node(p, {name = "automation_machines:boiler_empty"})
							end
						end
					end
				end
			end
		end
		for dx = -1, 1 do
			for dz = -1, 1 do
				if not (dx == 0 and dz == 0) then
					local p = {x = pos.x+dx, y=pos.y, z = pos.z+dz}
					local n = minetest.registered_nodes[minetest.get_node(p).name]
					if n and n.on_automation_rotate then
						n.on_automation_rotate(p, pos, 220)
					end
				end
			end
		end
	end,
})

-- axle

minetest.register_node("automation_machines:axle", {
	description = "Axle",
	tiles = {"automation_metal.png"},
	groups = {choppy = 3, axle = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.1, -0.1, -0.5, 0.1, 0.1, 0.5},
			},
	},
	on_automation_rotate = function(pos, from, force)
		if force < 1 then
			return
		end
		print("[automation] rotate")
		local dir = vector.multiply(vector.subtract(from,pos), -1)
		local next_pos = vector.add(pos, dir)
		print(minetest.pos_to_string(next_pos))
		local node = minetest.registered_nodes[minetest.get_node(next_pos).name]

		if node and node.on_automation_rotate then
			node.on_automation_rotate(next_pos, pos, force-1)
		end
	end,
})

minetest.register_craft({
	output = 'automation_machines:axle',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

-- bevel gear

minetest.register_node("automation_machines:bevel_gear", {
	description = "Bevel Gear",
	tiles = {"automation_metal.png"},
	groups = {choppy = 3, gear= 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-0.2, -0.2, -0.2, 0.2, 0.2, 0.2},},

		connect_back = {{-0.1, -0.1, 0, 0.1, 0.1, 0.5}},
		connect_left = {{-0.5, -0.1, -0.1, 0, 0.1, 0.1}},
		connect_front = {{-0.1, -0.1, -0.5, 0.1, 0.1, 0}},
		connect_right = {{-0.0, -0.1, -0.1, 0.5, 0.1, 0.1}},
	},
	connects_to = {"group:axle", "group:gear", "group:spring", "group:machine", "automation_machines:crank"},

	on_automation_rotate = function(pos, from, force)
		print("[automation] rotate")
		local dirs = {vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1, 0, 0), vector.new(-1, 0, 0)}
		local n = 0
		for _,dir in pairs(dirs) do
			local next_pos = vector.add(pos, dir)
			if not(vector.equals(next_pos, from)) then
				local node = minetest.registered_nodes[minetest.get_node(next_pos).name]

				if node and node.on_automation_rotate then
					n = n +1;
				end
			end
		end

		for _,dir in pairs(dirs) do
			local next_pos = vector.add(pos, dir)
			if not(vector.equals(next_pos, from)) then
				local node = minetest.registered_nodes[minetest.get_node(next_pos).name]

				if node and node.on_automation_rotate then
					node.on_automation_rotate(next_pos, pos, force/n)
				end
			end
		end
	end,
})

minetest.register_craft({
	output = 'automation_machines:bevel_gear',
	recipe = {
		{'automation_machines:axle'}
	}
})
