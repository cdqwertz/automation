minetest.register_node("automation_pistons:piston", {
	description = "Piston",
	tiles = {"default_wood.png", "automation_strong_metal.png","default_wood.png^automation_piston_side.png"},
	groups = {choppy = 3},
	sounds =  default.node_sound_stone_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	on_automation_rotate = function(pos, from, force)
		if force > 10 then
			local node = minetest.get_node(pos)
			local a = {vector.new(0, 1, 0), vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1,0,0), vector.new(-1,0,0), vector.new(-1,0, 0)}			
			local d = a[math.floor(node.param2/4)+1]
			if minetest.get_node(vector.add(pos, vector.multiply(d,2))).name == "air" or minetest.get_node(vector.add(pos, d)).name == "air" then
				node.name = "automation_pistons:piston_on"
				minetest.swap_node(pos, node)
	
				if not(minetest.get_node(vector.add(pos, d)).name == "air") then
					minetest.set_node(vector.add(pos, vector.multiply(d,2)), minetest.get_node(vector.add(pos, d)))
				end

				minetest.set_node(vector.add(pos, d), {name = "automation_pistons:piston_pusher", param2 = node.param2})
			end
		end
	end,
})

minetest.register_node("automation_pistons:piston_on", {
	description = "Piston (ON)",
	tiles = {"automation_strong_metal.png"},
	groups = {choppy = 3, not_in_creative_inventory = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	on_automation_rotate = function(pos, from, force)
		if force > 10 then
			local node = minetest.get_node(pos)
			local a = {vector.new(0, 1, 0), vector.new(0, 0, 1), vector.new(0, 0, -1), vector.new(1,0,0), vector.new(-1,0,0), vector.new(-1,0, 0)}			
			local d = a[math.floor(node.param2/4)+1]

			node.name = "automation_pistons:piston"
			minetest.swap_node(pos, node)

			minetest.set_node(vector.add(pos, d), {name = "air"})
		end
	end,
})

minetest.register_node("automation_pistons:piston_pusher", {
	description = "Piston (Pusher)",
	tiles = {"default_wood.png"},
	groups = {choppy = 3, not_in_creative_inventory = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype2 = "facedir",
	paramtype = "light",

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-2/16, -0.5, -2/16, 2/16, 0.5, 2/16}, {-0.5, 6/16, -0.5, 0.5, 0.5, 0.5}},
	},
})
