minetest.register_node("automation_pipes:pipe", {
	description = "Pipe",
	tiles = {"automation_pipe.png"},
	groups = {choppy = 3, pipe = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-4/16, -4/16, -4/16, 4/16, 4/16, 4/16},},
		
		connect_back = {{-4/16, -4/16, -4/16, 4/16, 4/16, 0.5}},
		connect_left = {{-0.5, -4/16, -4/16, 4/16, 4/16, 4/16}},
		connect_front = {{-4/16, -4/16, -0.5, 4/16, 4/16, 4/16}},
		connect_right = {{-4/16, -4/16, -4/16, 0.5, 4/16, 4/16}},
	},
	connects_to = {"group:pipe", "group:connects_to_pipe"},

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 1 then
			minetest.set_node(pos, {name = "automation_pipes:pipe_water"})
		end

		local dirs = {vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1, 0, 0), vector.new(-1, 0, 0)}
		for _,dir in pairs(dirs) do
			local next_pos = vector.add(pos, dir)
			if not(vector.equals(next_pos, from)) then
				local node = minetest.registered_nodes[minetest.get_node(next_pos).name]		

				if node and node.on_automation_pipe_update then
					node.on_automation_pipe_update(next_pos, pos, fluid)
				end
			end
		end
	end,
})

minetest.register_craft({
	output = 'automation_pipes:pipe 6',
	recipe = {
		{'default:glass', 'default:glass', 'default:glass'},
		{'', '', ''},
		{'default:glass', 'default:glass', 'default:glass'},
	}
})

minetest.register_node("automation_pipes:pipe_water", {
	description = "Pipe with Water",
	tiles = {"automation_pipe_water.png"},
	groups = {choppy = 3, pipe = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-4/16, -4/16, -4/16, 4/16, 4/16, 4/16},},
		
		connect_back = {{-4/16, -4/16, -4/16, 4/16, 4/16, 0.5}},
		connect_left = {{-0.5, -4/16, -4/16, 4/16, 4/16, 4/16}},
		connect_front = {{-4/16, -4/16, -0.5, 4/16, 4/16, 4/16}},
		connect_right = {{-4/16, -4/16, -4/16, 0.5, 4/16, 4/16}},
	},
	connects_to = {"group:pipe", "group:connects_to_pipe"},

	drop = "automation_pipes:pipe",

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 0 then
			minetest.set_node(pos, {name = "automation_pipes:pipe"})
		end

		local dirs = {vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1, 0, 0), vector.new(-1, 0, 0)}
		for _,dir in pairs(dirs) do
			local next_pos = vector.add(pos, dir)
			if not(vector.equals(next_pos, from)) then
				local node = minetest.registered_nodes[minetest.get_node(next_pos).name]		

				if node and node.on_automation_pipe_update then
					node.on_automation_pipe_update(next_pos, pos, fluid)
				end
			end
		end
	end,
})

minetest.register_node("automation_pipes:pump", {
	description = "Pump",
	tiles = {"automation_pump.png", "automation_pump.png", "automation_pump_side.png"},
	groups = {choppy = 3, pump = 1, connects_to_pipe = 1, machine=1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-6/16, -8/16, -6/16, 6/16, 5/16, 6/16},
			{-8/16, -8/16, -8/16, 8/16, -5/16, 8/16},},

		connect_back = {{-4/16, -4/16, -4/16, 4/16, 4/16, 0.5}},
		connect_left = {{-0.5, -4/16, -4/16, 4/16, 4/16, 4/16}},
		connect_front = {{-4/16, -4/16, -0.5, 4/16, 4/16, 4/16}},
		connect_right = {{-4/16, -4/16, -4/16, 0.5, 4/16, 4/16}},
	},

	connects_to = {"group:pipe"},

	on_automation_rotate = function(pos, from, force)
		if force > 100 then
			local fluid = 0
			
			if minetest.get_node(vector.new(pos.x, pos.y-1, pos.z)).name == "default:water_source" then
				fluid = 1
			end

			local dirs = {vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1, 0, 0), vector.new(-1, 0, 0)}
			for _,dir in pairs(dirs) do
				local next_pos = vector.add(pos, dir)
				if not(vector.equals(next_pos, from)) then
					local node = minetest.registered_nodes[minetest.get_node(next_pos).name]		

					if node and node.on_automation_pipe_update then
						node.on_automation_pipe_update(next_pos, pos, fluid)
					end
				end
			end
		end
	end,

	on_automation_pipe_update = function(pos, from, fluid)
		if fluid == 0 then
			minetest.set_node(pos, {name = "automation_pipes:pipe"})
		end

		local dirs = {vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1, 0, 0), vector.new(-1, 0, 0)}
		for _,dir in pairs(dirs) do
			local next_pos = vector.add(pos, dir)
			if not(vector.equals(next_pos, from)) then
				local node = minetest.registered_nodes[minetest.get_node(next_pos).name]		

				if node and node.on_automation_pipe_update then
					node.on_automation_pipe_update(next_pos, pos, fluid)
				end
			end
		end
	end,
})

minetest.register_craft({
	output = 'automation_pipes:pump',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_pistons:piston', 'automation_materials:metal'},
		{'automation_materials:metal', 'automation_pipes:pipe', 'automation_materials:metal'},
	}
})
