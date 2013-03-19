---
--Fire extinguisher 1.00
--Copyright (C) 2013 Bad_Command
--
--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public
--License along with this library; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
----

fireextinguisher = {}
fireextinguisher.version = 1.00

-- config.lua contains configuration parameters
dofile(minetest.get_modpath("fireextinguisher").."/config.lua")
-- bones.lua contains the code
dofile(minetest.get_modpath("fireextinguisher").."/fireextinguisher.lua")


minetest.register_node("fireextinguisher:fireextinguisher", {
	description = "Automatic Fire Extinguisher",
	tile_images ={"fireextinguisher.png"},
	paramtype = "light",
	paramtype2 = "none",
	drawtype = "plantlike",
	groups = {oddly_breakable_by_hand=1},
	pointable = true,
	diggable = true,
	damage_per_second = 0,
})


minetest.register_node("fireextinguisher:fireretardant", {
	description = "Fire Retardant Foam",
	tile_images ={"retardant.png"},
	paramtype = "light",
	paramtype2 = "none",
	drawtype = "plantlike",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {dig_immediate=3, oddly_breakable_by_hand=3, puts_out_fire=1},
	pointable = true,
	diggable = true,
	damage_per_second = 0,
	after_place_node = function(pos, placer)
		minetest.env:set_node(pos, {name="fireextinguisher:fireretardant", param1=14, param2=fireextinguisher.retardant_strength})
	end
})

minetest.register_node("fireextinguisher:retardantcat", {
	description = "Fire Retardant Foam Spray",
	tile_images ={"retardantc.png"},
	paramtype = "light",
	paramtype2 = "none",
	groups = {immortal=1, puts_out_fire=1},
	walkable = false,
	drawtype = "glasslike",
	sunlight_propagates = true,
	pointable = false,
	diggable = false,
	damage_per_second = 0,
})

minetest.register_node("fireextinguisher:retardantcleanercat", {
	description = "Fire Retardant Foam Cleaner",
	tile_images ={"retardantcc.png"},
	paramtype = "light",
	paramtype2 = "none",
	walkable = false,
	groups = {immortal=1},
	drawtype = "glasslike",
	sunlight_propagates = true,
	pointable = false,
	diggable = false,
	damage_per_second = 0,
	after_place_node = function(pos, node, active_object_count, active_object_count_wider) 
		minetest.env:set_node(pos, {name="fireextinguisher:retardantcleanercat", param1=14, param2=fireextinguisher.retardantcleanercat_lifespan})	
	end
})

minetest.register_craft({
	output = 'fireextinguisher:fireextinguisher',
	recipe = {
                {'bucket:bucket_water', 'default:torch', 'default:mese'},
                {'', 'default:steel_ingot', ''},
                {'', '', ''},
        },
	replacements = { {'bucket:bucket_water', 'bucket:bucket_empty'} }
})

minetest.register_craft({
	output = 'fireextinguisher:retardantcleanercat',
	recipe = {
                {'fireextinguisher:fireretardant', 'fireextinguisher:fireretardant', 'fireextinguisher:fireretardant'},
                {'default:torch', 'default:torch', 'default:torch'},
                {'', '', ''},
        }
})


minetest.register_abm({
	nodenames = {"fireextinguisher:fireextinguisher"},
	neighbors = {"default:lava_source", "default:lava_flowing", "fire:basic_flame"},
	interval = 0.05,
	chance = 1,
	action = fireextinguisher.fireextinguisher_abm
})

minetest.register_abm({
	nodenames = {"fireextinguisher:fireretardant"},
	neighbors = {"fire:basic_flame"},
	interval = 0.03,
	chance = 1,
	action = fireextinguisher.retardant_abm
})

minetest.register_abm({
	nodenames = {"fireextinguisher:fireretardant"},
	neighbors = {"air"},
	interval = 1,
	chance = 2,
	action = fireextinguisher.retardant_evaporate_abm
})

minetest.register_abm(
	{nodenames = {"fireextinguisher:retardantcat"},
	interval = 0.01,
	chance = 3,
	action = fireextinguisher.retardantcat_abm
})

minetest.register_abm(
	{nodenames = {"fireextinguisher:retardantcleanercat"},
	interval = 0.3,
	chance = 2,
	action = fireextinguisher.retardantcleanercat_abm
})


