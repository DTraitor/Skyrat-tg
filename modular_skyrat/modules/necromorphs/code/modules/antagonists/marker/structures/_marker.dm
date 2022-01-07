//I will need to recode parts of this but I am way too tired atm //I don't know who left this comment but they never did come back
/obj/structure/marker
	name = "growth"
	icon = 'icons/mob/blob.dmi'//	icon_state = 'marker_normal_dormant'
	light_range = 2
	desc = "A thick wall of writhing tendrils."
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	pass_flags_self = PASSBLOB
	CanAtmosPass = ATMOS_PASS_PROC
	/// How many points the marker gets back when it removes a marker of that type. If less than 0, marker cannot be removed.
	var/point_return = 0
	max_integrity = 30
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 70)
	/// how much health this marker regens when pulsed
	var/health_regen = MARKER_REGULAR_HP_REGEN
	/// We got pulsed when?
	COOLDOWN_DECLARE(pulse_timestamp)
	/// we got healed when?
	COOLDOWN_DECLARE(heal_timestamp)
	/// Multiplies brute damage by this
	var/brute_resist = MARKER_BRUTE_RESIST
	/// Multiplies burn damage by this
	var/fire_resist = MARKER_FIRE_RESIST
	/// Only used by the synchronous mesh . If set to true, these markers won't share or receive damage taken with others.
	var/ignore_syncmesh_share = 0
	/// If the marker blocks atmos and heat spread
	var/atmosblock = FALSE
	var/mob/camera/marker/overmind


/obj/structure/marker/Initialize(mapload, owner_overmind)
	. = ..()
	if(owner_overmind)
		overmind = owner_overmind
		overmind.all_markers += src
		var/area/Amarker = get_area(src)
		if(Amarker.area_flags & BLOBS_ALLOWED) //Is this area allowed for winning as marker?
			overmind.markers_legit += src
	GLOB.markers += src //Keep track of the marker in the normal list either way
	setDir(pick(GLOB.cardinals))
	update_appearance()
	if(atmosblock)
		air_update_turf(TRUE, TRUE)
	ConsumeTile()

/obj/structure/marker/proc/creation_action() //When it's created by the overmind, do this.
	return

/obj/structure/marker/Destroy()
	if(atmosblock)
		atmosblock = FALSE
		air_update_turf(TRUE, FALSE)
	if(overmind)
		overmind.all_markers -= src
		overmind.markers_legit -= src  //if it was in the legit markers list, it isn't now
		overmind = null
	GLOB.markers -= src //it's no longer in the all markers list either
	playsound(src.loc, 'sound/effects/splat.ogg', 50, TRUE) //Expand() is no longer broken, no check necessary.
	return ..()

/obj/structure/marker/marker_act()
	return

/obj/structure/marker/Adjacent(atom/neighbour)
	. = ..()
	if(.)
		var/result = 0
		var/direction = get_dir(src, neighbour)
		var/list/dirs = list("[NORTHWEST]" = list(NORTH, WEST), "[NORTHEAST]" = list(NORTH, EAST), "[SOUTHEAST]" = list(SOUTH, EAST), "[SOUTHWEST]" = list(SOUTH, WEST))
		for(var/A in dirs)
			if(direction == text2num(A))
				for(var/B in dirs[A])
					var/C = locate(/obj/structure/marker) in get_step(src, B)
					if(C)
						result++
		. -= result - 1

/obj/structure/marker/BlockSuperconductivity()
	return atmosblock

/obj/structure/marker/CanAtmosPass(turf/T)
	return !atmosblock

/obj/structure/marker/update_icon() //Updates color based on overmind color if we have an overmind.
	. = ..()


/obj/structure/marker/proc/Be_Pulsed()
	if(COOLDOWN_FINISHED(src, pulse_timestamp))
		ConsumeTile()
		if(COOLDOWN_FINISHED(src, heal_timestamp))
			obj_integrity = min(max_integrity, obj_integrity+health_regen)
			COOLDOWN_START(src, heal_timestamp, 20)
		update_appearance()
		COOLDOWN_START(src, pulse_timestamp, 10)
		return TRUE//we did it, we were pulsed!
	return FALSE //oh no we failed

/obj/structure/marker/proc/ConsumeTile()
	for(var/atom/A in loc)
		if(isliving(A) && overmind && !ismarkermonster(A)) // Make sure to inject strain-reagents with automatic attacks when needed.
			continue // Don't smack them twice though
			A.marker_act(src)
	if(iswallturf(loc))
		loc.marker_act(src) //don't ask how a wall got on top of the core, just eat it


/obj/structure/marker/proc/expand(turf/T = null, controller = null, expand_reaction = 1)
	if(!T)
		var/list/dirs = list(1,2,4,8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/structure/marker) in T))
				break
			else
				T = null
	if(!T)
		return
	var/make_marker = TRUE //can we make a marker?

	if(isspaceturf(T) && !(locate(/obj/structure/lattice) in T) && prob(80))
		make_marker = FALSE
		playsound(src.loc, 'sound/effects/splat.ogg', 50, TRUE) //Let's give some feedback that we DID try to spawn in space, since players are used to it

	ConsumeTile() //hit the tile we're in, making sure there are no border objects blocking us
	if(!T.CanPass(src, T)) //is the target turf impassable
		make_marker = FALSE
		T.marker_act(src) //hit the turf if it is
	for(var/atom/A in T)
		if(!A.CanPass(src, T)) //is anything in the turf impassable
			make_marker = FALSE
			continue // Don't smack them twice though
		A.marker_act(src) //also hit everything in the turf

	if(make_marker) //well, can we?
		var/obj/structure/marker/B = new /obj/structure/marker/normal(src.loc, (controller || overmind))
		B.density = TRUE
		if(T.Enter(B,src)) //NOW we can attempt to move into the tile
			B.density = initial(B.density)
			B.forceMove(T)
			B.update_appearance()
			return B
		else
			T.marker_act(src) //if we can't move in hit the turf again
			qdel(B) //we should never get to this point, since we checked before moving in. destroy the blob so we don't have two blobs on one tile
			return
	return

/obj/structure/marker/hulk_damage()
	return 15

/obj/structure/marker/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_ANALYZER)
		user.changeNext_move(CLICK_CD_MELEE)
		to_chat(user, "<b>The analyzer beeps once, then reports:</b><br>")
		SEND_SOUND(user, sound('sound/machines/ping.ogg'))
		if(overmind)
			to_chat(user, "<b>Progress to Critical Mass:</b> [span_notice("[overmind.markers_legit.len]/[overmind.markerwincount].")]")
			to_chat(user, chemeffectreport(user).Join("\n"))
		else
			to_chat(user, "<b>Marker core neutralized. Critical mass no longer attainable.</b>")
		to_chat(user, typereport(user).Join("\n"))
	else
		return ..()

/obj/structure/marker/proc/chemeffectreport(mob/user)
	RETURN_TYPE(/list)
	. = list()

/obj/structure/marker/proc/typereport(mob/user)
	RETURN_TYPE(/list)
	return list()


/obj/structure/marker/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(ROLE_NECROMORPH in user.faction) //sorry, but you can't kill the marker as a markerbernaut
		return
	..()

/obj/structure/marker/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/effects/attackblob.ogg', 50, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/marker/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	switch(damage_type)
		if(BRUTE)
			damage_amount *= brute_resist
		if(BURN)
			damage_amount *= fire_resist
		if(CLONE)
		else
			return 0
	var/armor_protection = 0
	if(damage_flag)
		armor_protection = armor.getRating(damage_flag)
	damage_amount = round(damage_amount * (100 - armor_protection)*0.01, 0.1)
	return damage_amount

/obj/structure/marker/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && obj_integrity > 0)
		update_appearance()

/obj/structure/marker/obj_destruction(damage_flag)
	..()

/obj/structure/marker/proc/change_to(type, controller)
	if(!ispath(type))
		CRASH("change_to(): invalid type for marker")
	var/obj/structure/marker/B = new type(src.loc, controller)
	B.creation_action()
	B.update_appearance()
	B.setDir(dir)
	qdel(src)
	return B

/obj/structure/marker/examine(mob/user)
	. = ..()
	var/datum/atom_hud/hud_to_check = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	if(user.research_scanner || hud_to_check.hudusers[user])
		. += "<b>Your HUD displays an extensive report...</b><br>"
		if(overmind)
			. += overmind.examine(user)
		else
			. += "<b>Core neutralized. Critical mass no longer attainable.</b>"
		. += chemeffectreport(user)
		. += typereport(user)
	else
		if((user == overmind || isobserver(user)) && overmind)
			. += overmind.examine(user)
		. += "It seems to be made of unknown."

/obj/structure/marker/proc/scannerreport()
	return "A generic marker. Looks like someone forgot to override this proc, adminhelp this."

/obj/structure/marker/normal
	name = "normal growth"
	icon_state = "blob"
	light_range = 0
	max_integrity = MARKER_REGULAR_MAX_HP
	health_regen = MARKER_REGULAR_HP_REGEN
	brute_resist = MARKER_BRUTE_RESIST * 0.5

/obj/structure/marker/normal/scannerreport()
	if(obj_integrity <= 15)
		return "Currently weak to brute damage."
	return "N/A"

/obj/structure/marker/normal/update_name()
	. = ..()
	name = "[(obj_integrity <= 15) ? "fragile " : (overmind ? null : "dead ")][initial(name)]"

/obj/structure/marker/normal/update_desc()
	. = ..()
	if(obj_integrity <= 15)
		desc = "A thin lattice of slightly twitching tendrils."
	else if(overmind)
		desc = "A thick wall of writhing tendrils."
	else
		desc = "A thick wall of lifeless tendrils."

/obj/structure/marker/normal/update_icon_state()
	icon_state = "blob[(obj_integrity <= 15) ? "_damaged" : null]"

	/// - [] TODO: Move this elsewhere
	if(obj_integrity <= 15)
		brute_resist = MARKER_BRUTE_RESIST
	else if (overmind)
		brute_resist = MARKER_BRUTE_RESIST * 0.5
	else
		brute_resist = MARKER_BRUTE_RESIST * 0.5
	return ..()

/obj/structure/marker/special // Generic type for nodes/factories/cores/resource
	// Core and node vars: claiming, pulsing and expanding
	/// The radius inside which (previously dead) marker tiles are 'claimed' again by the pulsing overmind. Very rarely used.
	var/claim_range = 0
	/// The radius inside which markers are pulsed by this overmind. Does stuff like expanding, making marker slashers from factories, make resources from nodes etc.
	var/pulse_range = 0
	/// The radius up to which this special structure naturally grows normal markers.
	var/expand_range = 0

	// Slasher production vars: for core, factories, and nodes (with s)

	var/mob/living/simple_animal/hostile/necromorph/slasher = null
	var/mob/living/simple_animal/hostile/necromorph/brute = null

	var/max_spores = 0
	var/list/spores = list()
	COOLDOWN_DECLARE(spore_delay)
	var/spore_cooldown = MARKERMOB_SLASHER_SPAWN_COOLDOWN

	var/max_slashers = 0
	var/list/slashers = list()
	COOLDOWN_DECLARE(slasher_delay)
	var/slasher_cooldown = BLOBMOB_SPORE_SPAWN_COOLDOWN

	// Area reinforcement vars: used by cores and nodes, for s to modify
	/// Range this marker free upgrades to strong markers at: for the core, and for s
	var/strong_reinforce_range = 0
	/// Range this marker free upgrades to reflector markers at: for the core, and for s
	var/reflector_reinforce_range = 0


/obj/structure/marker/special/proc/pulse_area(mob/camera/marker/pulsing_overmind, claim_range = 10, pulse_range = 3, expand_range = 2)
	if(QDELETED(pulsing_overmind))
		pulsing_overmind = overmind
	Be_Pulsed()
	var/expanded = FALSE
	if(prob(70*(1/MARKER_EXPAND_CHANCE_MULTIPLIER)) && expand())
		expanded = TRUE
	var/list/markers_to_affect = list()
	for(var/obj/structure/marker/B in urange(claim_range, src, 1))
		markers_to_affect += B
	shuffle_inplace(markers_to_affect)
	for(var/L in markers_to_affect)
		var/obj/structure/marker/B = L
		if(!B.overmind && prob(30))
			B.overmind = pulsing_overmind //reclaim unclaimed, non-core markers.
			B.update_appearance()
		var/distance = get_dist(get_turf(src), get_turf(B))
		var/expand_probablity = max(20 - distance * 8, 1)
		if(B.Adjacent(src))
			expand_probablity = 20
		if(distance <= expand_range)
			var/can_expand = TRUE
			if(markers_to_affect.len >= 120 && !(COOLDOWN_FINISHED(B, heal_timestamp)))
				can_expand = FALSE
			if(can_expand && COOLDOWN_FINISHED(B, pulse_timestamp) && prob(expand_probablity*MARKER_EXPAND_CHANCE_MULTIPLIER))
				if(!expanded)
					var/obj/structure/marker/newB = B.expand(null, null, !expanded) //expansion falls off with range but is faster near the marker causing the expansion
					if(newB)
						expanded = TRUE
		if(distance <= pulse_range)
			B.Be_Pulsed()

/obj/structure/marker/special/proc/produce_slashers()
	if(brute)
		return
	if(slashers.len >= max_slashers)
		return
	if(!COOLDOWN_FINISHED(src, slasher_delay))
		return
	COOLDOWN_START(src, slasher_delay, slasher_cooldown)
	var/mob/living/simple_animal/hostile/necromorph/slasher/BS = new (loc, src)
	if(overmind) //if we don't have an overmind, we don't need to do anything but make a slasher
		//BS.overmind = overmind
		BS.update_icons()
		overmind.marker_mobs.Add(BS)

/obj/structure/marker/special/proc/produce_spores()
	if(brute)
		return
	if(slashers.len >= max_slashers)
		return
	if(!COOLDOWN_FINISHED(src, slasher_delay))
		return
	COOLDOWN_START(src, slasher_delay, slasher_cooldown)
	var/mob/living/simple_animal/hostile/necromorph/slasher/BS = new (loc, src)
	if(overmind) //if we don't have an overmind, we don't need to do anything but make a slasher
		//BS.overmind = overmind
		BS.update_icons()
		overmind.marker_mobs.Add(BS)
