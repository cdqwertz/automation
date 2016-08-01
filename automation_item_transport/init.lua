minetest.register_node("automation_item_transport:fan", {
	description = "Fan",
	tiles = {"automation_metal.png", "automation_metal.png", "automation_metal.png", "automation_metal.png", "automation_metal.png", "automation_fan.png"},
	groups = {choppy = 3, machine = 1},
	sounds =  default.node_sound_stone_defaults(),
	paramtype2 = "facedir",
	on_automation_rotate = function(pos, from, force)
		if force > 20 then
			local d = vector.multiply(minetest.facedir_to_dir(minetest.get_node(pos).param2), -1)
			local p = vector.add(pos, d)

			minetest.add_particlespawner({
				amount = 200,
				time = 1,
				minpos = vector.add(pos, vector.new(-0.5, -0.5, -0.5)),
				maxpos = vector.add(vector.add(p, vector.new(0.5, 0.5, 0.5)), vector.multiply(d, 3)),
				minvel = d,
				maxvel = d,
				minacc = {x=0, y=0, z=0},
				maxacc = {x=0, y=0, z=0},
				minexptime = 1,
				maxexptime = 3,
				minsize = 1,
				maxsize = 3,
				collisiondetection = false,
				vertical = false,
				texture = "automation_particle_wind.png",
			})

			for i=0,3,1 do
				local objs = minetest.get_objects_inside_radius(p, 0.5)
				for _,obj in ipairs(objs) do
					local target = vector.add(p, d)
					print(minetest.get_node(target).name)
					print(minetest.registered_nodes[minetest.get_node(target).name].walkable)
					if minetest.registered_nodes[minetest.get_node(target).name].walkable == false or minetest.get_node(target).name == "automation_item_transport:slime_carpet" then
						obj:moveto(target, false)
					end
				end
				p = vector.add(p, d)
			end
		end
	end,
})

minetest.register_craft({
	output = 'automation_item_transport:fan',
	recipe = {
		{'automation_materials:metal', 'automation_materials:metal', 'default:steel_ingot'},
		{'automation_materials:metal', 'automation_machines:axle', 'default:steel_ingot'},
		{'automation_materials:metal', 'automation_materials:metal', 'default:steel_ingot'},
	}
})

minetest.register_node("automation_item_transport:slime_block", {
	description = "Slime Block",
	tiles = {"automation_slime.png"},
	groups = {crumbly = 3, bouncy=75, fall_damage_add_percent=-100},
	sounds =  default.node_sound_dirt_defaults(),
})

minetest.register_node("automation_item_transport:slime_carpet", {
	description = "Slime Carpet",
	tiles = {"automation_slime.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, -6/16, 0.5},
			},
	},
	paramtype = "light",
	groups = {crumbly = 3, bouncy=75, fall_damage_add_percent=-100},
	sounds =  default.node_sound_dirt_defaults(),
})

minetest.register_node("automation_item_transport:magent", {
	description = "Magnet",
	tiles = {"automation_magnet_top.png", "automation_magnet_bottom.png", "automation_magnet_side.png"},
	groups = {choppy = 3, machine = 1},
	sounds =  default.node_sound_stone_defaults(),

	on_automation_rotate = function(pos, from, force)
		if force > 90 then
			local objs = minetest.get_objects_inside_radius(pos, 4)
			for _,obj in ipairs(objs) do
				obj:moveto(vector.add(pos, vector.new(0, 1, 0)), false)
			end
		end
	end,
})
