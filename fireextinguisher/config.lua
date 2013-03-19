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

fireextinguisher.retardant_strength = 5;
fireextinguisher.retardant_strength_pure = 10

fireextinguisher.retardantcat_lifespan = 10
fireextinguisher.retardantcat_targets = {'air', 'fire:basic_flame', 'ignore'}
fireextinguisher.retardantcat_poisons = {'fireextinguisher:retardantcleanercat'}
fireextinguisher.retardant_replacement = 
	{node="fireextinguisher:fireretardant", param2=fireextinguisher.retardant_strength_pure	}



fireextinguisher.retardantcleanercat_lifespan = 35
fireextinguisher.retardantcleanercat_targets = {'fireextinguisher:fireretardant', 'ignore'}
fireextinguisher.retardantcleanercat_poisons = {'fireextinguisher:retardantcat'}
fireextinguisher.retardantcleanercat_replacement = 
	{node="air", param2=10}

