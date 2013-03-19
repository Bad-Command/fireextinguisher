---
--Fire extinguisher
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

fireextinguisher.fireextinguisher_abm=function(pos, node, active_object_count, active_object_count_wider)
	minetest.sound_play("fireextinguisher_hiss", {pos = pos, gain = 1.3, max_hear_distance = fireextinguisher.retardantcat_lifespan*3})
	node =  {name="fireextinguisher:retardantcat", param1=14, param2=fireextinguisher.retardantcat_lifespan}
	minetest.env:set_node(pos, node)
	fireextinguisher.retardantcat_abm(pos, node, nil, nil)
end

fireextinguisher.retardantcat_abm=function(pos, node, active_object_count, active_object_count_wider)
	fireextinguisher.run(pos, node, fireextinguisher.retardantcat_targets, fireextinguisher.retardant_replacement, fireextinguisher.retardantcat_lifespan, fireextinguisher.retardantcat_poisons)
end

fireextinguisher.retardantcleanercat_abm=function(pos, node, active_object_count, active_object_count_wider)
	fireextinguisher.run(pos, node, fireextinguisher.retardantcleanercat_targets, fireextinguisher.retardantcleanercat_replacement, fireextinguisher.retardantcleanercat_lifespan, fireextinguisher.retardantcleanercat_poisons)
end

fireextinguisher.retardant_abm=function(pos, node, active_object_count, active_object_count_wider)
	flames = minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {'fire:basic_flame'})
	for i=1,#flames do
			if node.param2 > 0 then
				minetest.env:set_node(flames[i], {name=node.name, param1=14, param2=node.param2-1})
			else
				minetest.env:remove_node(flames[i])
			end
			
	end
	for i=1,#flames do
			fire.on_flame_remove_at(flames[i])
	end
end

fireextinguisher.retardant_evaporate_abm=function(pos, node, active_object_count, active_object_count_wider)
	retardant_or_air = minetest.env:find_nodes_in_area(
		{x=pos.x-1, y=pos.y-1, z=pos.z-1}, 
		{x=pos.x+1, y=pos.y+1, z=pos.z+1}, 
		{'air', 'fireextinguisher:fireretardant', 'default:lava_source', 'default:lava_flowing'})
	if ( #retardant_or_air == 27 ) then
		below = {x=pos.x, y=pos.y-1, z=pos.z}
		if ( minetest.env:get_node(below).name == 'air' and node.param2 > 0 ) then
			minetest.env:set_node(below, {name=node.name, param1=node.param1, param2=node.param2-1})
		end
		minetest.env:set_node(pos, {name='air', param1=0, param2=0})
	end	
end



fireextinguisher.replace = function(pos, node, repl)
	minetest.env:set_node(pos, {name=repl.node, param1=0, param2=repl.param2})

	if ( node ~= nil and node.name == 'fire:basic_flame' ) then
		fire.on_flame_remove_at(flames[i])		
	end
end

fireextinguisher.propagate = function(pos, node, replacementnodename, life) 
	if ( target.name == 'fire:basic_flame' ) then
		minetest.env:remove_node(pos)
		fire.on_flame_remove_at(pos)
	end

	minetest.env:set_node(pos, {name=replacementnodename, param1=14, param2=life-1})
end

fireextinguisher.run = function(pos, node, targettypes, replacement, lifespan, poisontypes)
	life = node.param2

	if ( life == 0 ) then
		fireextinguisher.replace(pos, nil, replacement)
		return
	end

	poisoned = false
	if ( poisontypes ~= nil ) then
		poisoned = minetest.env:find_node_near(pos, 1, poisontypes) ~= nil
	end

	ignoreAdjacentNodeFound = false
	propagated = false

	if ( not poisoned ) then
		targets = minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, targettypes)
		for i=1,#targets do
			target = minetest.env:get_node(targets[i])
			if ( target.name ~= 'ignore' ) then
				fireextinguisher.propagate(targets[i], target, node.name, life)
				propagated = true;
			else
				ignoreAdjacentNodeFound = true
			end
		end
	end
	if ( ignoreAdjacentNodeFound == false or poisoned ) then
		if ( propagated or life ~= lifespan ) then
			fireextinguisher.replace(pos, nil, replacement)
		else
			minetest.env:set_node(pos, {name='air', param1=0, param2=0})
		end
	end
end

