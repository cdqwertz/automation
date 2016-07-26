minetest.register_node("automation_pipes:pipe", {
	description = "Pipe (WIP)",
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
	connects_to = {"group:pipe"},

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
	connects_to = {"group:pipe"},

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
