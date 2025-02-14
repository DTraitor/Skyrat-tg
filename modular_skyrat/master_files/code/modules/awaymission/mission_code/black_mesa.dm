/area/awaymission/black_mesa
	name = "Black Mesa Inside"

/area/awaymission/black_mesa/outside
	name = "Black Mesa Outside"
	static_lighting = FALSE

/turf/closed/mineral/black_mesa
	turf_type = /turf/open/floor/plating/beach/sand/black_mesa
	baseturfs = /turf/open/floor/plating/beach/sand/black_mesa
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

//Floors that no longer lead into space (innovative!)
/turf/open/floor/plating/beach/sand/black_mesa
	baseturfs = /turf/open/floor/plating/beach/sand/black_mesa
	name = "sand"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/obj/effect/baseturf_helper/black_mesa
	name = "black mesa sand baseturf editor"
	baseturf = /turf/open/floor/plating/beach/sand/black_mesa

/mob/living/simple_animal/hostile/blackmesa
	var/list/alert_sounds
	var/alert_cooldown = 3 SECONDS
	var/alert_cooldown_time

/mob/living/simple_animal/hostile/blackmesa/xen
	faction = list(FACTION_XEN)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

/mob/living/simple_animal/hostile/blackmesa/Aggro()
	if(alert_sounds)
		if(!(world.time <= alert_cooldown_time))
			playsound(src, pick(alert_sounds), 70)
			alert_cooldown_time = world.time + alert_cooldown

/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid
	name = "bullsquid"
	desc = "Some highly aggressive alien creature. Thrives in toxic environments."
	icon = 'modular_skyrat/master_files/icons/mob/blackmesa.dmi'
	icon_state = "bullsquid"
	icon_living = "bullsquid"
	icon_dead = "bullsquid_dead"
	icon_gib = null
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	speak_chance = 1
	speak_emote = list("growls")
	emote_taunt = list("growls", "snarls", "grumbles")
	taunt_chance = 100
	turns_per_move = 7
	maxHealth = 110
	health = 110
	obj_damage = 50
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = TRUE
	retreat_distance = 4
	minimum_distance = 4
	dodging = TRUE
	projectiletype = /obj/projectile/bullsquid
	projectilesound = 'modular_skyrat/master_files/sound/blackmesa/bullsquid/goo_attack3.ogg'
	melee_damage_upper = 18
	attack_sound = 'modular_skyrat/master_files/sound/blackmesa/bullsquid/attack1.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	alert_sounds = list(
		'modular_skyrat/master_files/sound/blackmesa/bullsquid/detect1.ogg',
		'modular_skyrat/master_files/sound/blackmesa/bullsquid/detect2.ogg',
		'modular_skyrat/master_files/sound/blackmesa/bullsquid/detect3.ogg'
	)

/obj/projectile/bullsquid
	name = "nasty ball of ooze"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = BURN
	nodamage = FALSE
	knockdown = 20
	flag = BIO
	impact_effect_type = /obj/effect/temp_visual/impact_effect/neurotoxin
	hitsound = 'modular_skyrat/master_files/sound/blackmesa/bullsquid/splat1.ogg'
	hitsound_wall = 'modular_skyrat/master_files/sound/blackmesa/bullsquid/splat1.ogg'

/obj/projectile/bullsquid/on_hit(atom/target, blocked, pierce_hit)
	new /obj/effect/decal/cleanable/greenglow(target.loc)
	return ..()

/mob/living/simple_animal/hostile/blackmesa/xen/houndeye
	name = "houndeye"
	desc = "Some highly aggressive alien creature. Thrives in toxic environments."
	icon = 'modular_skyrat/master_files/icons/mob/blackmesa.dmi'
	icon_state = "houndeye"
	icon_living = "houndeye"
	icon_dead = "houndeye_dead"
	icon_gib = null
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	speak_chance = 1
	speak_emote = list("growls")
	speed = 1
	emote_taunt = list("growls", "snarls", "grumbles")
	taunt_chance = 100
	turns_per_move = 7
	maxHealth = 110
	health = 110
	obj_damage = 50
	harm_intent_damage = 10
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_sound = 'sound/weapons/bite.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	//Since those can survive on Xen, I'm pretty sure they can thrive on any atmosphere

	minbodytemp = 0
	maxbodytemp = 1500
	loot = list(/obj/item/stack/sheet/bluespace_crystal)
	alert_sounds = list(
		'modular_skyrat/master_files/sound/blackmesa/houndeye/he_alert1.ogg',
		'modular_skyrat/master_files/sound/blackmesa/houndeye/he_alert2.ogg',
		'modular_skyrat/master_files/sound/blackmesa/houndeye/he_alert3.ogg',
		'modular_skyrat/master_files/sound/blackmesa/houndeye/he_alert4.ogg',
		'modular_skyrat/master_files/sound/blackmesa/houndeye/he_alert5.ogg'
	)
	/// Charging ability
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/charge

/mob/living/simple_animal/hostile/blackmesa/xen/houndeye/Initialize(mapload)
	. = ..()
	charge = new /datum/action/cooldown/mob_cooldown/charge/basic_charge()
	charge.Grant(src)

/mob/living/simple_animal/hostile/blackmesa/xen/houndeye/Destroy()
	QDEL_NULL(charge)
	return ..()

/mob/living/simple_animal/hostile/blackmesa/xen/houndeye/OpenFire()
	if(client)
		return
	charge.Trigger(target)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab
	name = "headcrab"
	desc = "Don't let it latch onto your hea-... hey, that's kinda cool."
	icon = 'modular_skyrat/master_files/icons/mob/blackmesa.dmi'
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	icon_gib = null
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	speak_chance = 1
	speak_emote = list("growls")
	speed = 1
	emote_taunt = list("growls", "snarls", "grumbles")
	taunt_chance = 100
	turns_per_move = 7
	maxHealth = 100
	health = 100
	harm_intent_damage = 15
	melee_damage_lower = 17
	melee_damage_upper = 17
	attack_sound = 'sound/weapons/bite.ogg'
	gold_core_spawnable = HOSTILE_SPAWN
	loot = list(/obj/item/stack/sheet/bone)
	alert_sounds = list(
		'modular_skyrat/master_files/sound/blackmesa/headcrab/alert1.ogg'
	)
	var/is_zombie = FALSE
	var/mob/living/carbon/human/oldguy
	/// Charging ability
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/charge

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/Initialize(mapload)
	. = ..()
	charge = new /datum/action/cooldown/mob_cooldown/charge/basic_charge()
	charge.Grant(src)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/Destroy()
	QDEL_NULL(charge)
	return ..()

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/OpenFire()
	if(client)
		return
	charge.Trigger(target)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/death(gibbed)
	. = ..()
	playsound(src, pick(list(
		'modular_skyrat/master_files/sound/blackmesa/headcrab/die1.ogg',
		'modular_skyrat/master_files/sound/blackmesa/headcrab/die2.ogg'
	)), 100)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(hit_atom && stat != DEAD)
		if(ishuman(hit_atom))
			var/mob/living/carbon/human/human_to_dunk = hit_atom
			if(!human_to_dunk.get_item_by_slot(ITEM_SLOT_HEAD) && prob(50)) //Anything on de head stops the head hump
				if(zombify(human_to_dunk))
					to_chat(human_to_dunk, span_userdanger("[src] latches onto your head as it pierces your skull, instantly killing you!"))
					playsound(src, 'modular_skyrat/master_files/sound/blackmesa/headcrab/headbite.ogg', 100)
					human_to_dunk.death(FALSE)

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/proc/zombify(mob/living/carbon/human/zombified_human)
	if(is_zombie)
		return FALSE
	is_zombie = TRUE
	if(zombified_human.wear_suit)
		var/obj/item/clothing/suit/armor/zombie_suit = zombified_human.wear_suit
		maxHealth += zombie_suit.armor.melee //That zombie's got armor, I want armor!
	maxHealth += 40
	health = maxHealth
	name = "zombie"
	desc = "A shambling corpse animated by a headcrab!"
	mob_biotypes |= MOB_HUMANOID
	melee_damage_lower += 8
	melee_damage_upper += 11
	obj_damage = 21 //now that it has a corpse to puppet, it can properly attack structures
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	movement_type = GROUND
	icon_state = ""
	zombified_human.hairstyle = null
	zombified_human.update_hair()
	zombified_human.forceMove(src)
	oldguy = zombified_human
	update_appearance()
	visible_message(span_warning("The corpse of [zombified_human.name] suddenly rises!"))
	return TRUE

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/death(gibbed)
	. = ..()
	if(oldguy)
		oldguy.forceMove(loc)
		oldguy = null
	if(is_zombie)
		if(prob(30))
			new /mob/living/simple_animal/hostile/blackmesa/xen/headcrab(loc) //OOOO it unlached!
			qdel(src)
			return
		cut_overlays()
		update_appearance()

/mob/living/simple_animal/hostile/blackmesa/xen/headcrab/update_overlays()
	. = ..()
	if(is_zombie)
		copy_overlays(oldguy, TRUE)
		var/mutable_appearance/blob_head_overlay = mutable_appearance('modular_skyrat/master_files/icons/mob/blackmesa.dmi', "headcrab_zombie")
		add_overlay(blob_head_overlay)

/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth
	name = "nihilanth"
	desc = "Holy shit."
	icon = 'modular_skyrat/master_files/icons/mob/nihilanth.dmi'
	icon_state = "nihilanth"
	icon_living = "nihilanth"
	base_pixel_x = -156
	pixel_x = -156
	base_pixel_y = -154
	speed = 3
	pixel_y = -154
	bound_height = 64
	bound_width = 64
	icon_dead = "bullsquid_dead"
	maxHealth = 3000
	health = 3000
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/projectile/nihilanth
	ranged = TRUE
	rapid = 3
	alert_cooldown = 2 MINUTES
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_verb_continuous = "lathes"
	attack_verb_simple = "lathe"
	attack_sound = 'sound/weapons/punch1.ogg'
	status_flags = NONE
	del_on_death = TRUE
	loot = list(/obj/effect/gibspawner/xeno, /obj/item/stack/sheet/bluespace_crystal/fifty, /obj/item/key/gateway)

/obj/item/stack/sheet/bluespace_crystal/fifty
	amount = 50

/obj/projectile/nihilanth
	name = "portal energy"
	icon_state = "seedling"
	damage = 20
	damage_type = BURN
	light_range = 2
	flag = ENERGY
	light_color = LIGHT_COLOR_YELLOW
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	nondirectional_sprite = TRUE

/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth/Aggro()
	. = ..()
	if(!(world.time <= alert_cooldown_time))
		alert_cooldown_time = world.time + alert_cooldown
		switch(health)
			if(0 to 999)
				playsound(src, pick(list('modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_pain01.ogg', 'modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_freeeemmaan01.ogg')), 100)
			if(1000 to 2999)
				playsound(src, pick(list('modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_youalldie01.ogg', 'modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_foryouhewaits01.ogg')), 100)
			if(3000 to 6000)
				playsound(src, pick(list('modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_whathavedone01.ogg', 'modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_deceiveyou01.ogg')), 100)
			else
				playsound(src, pick(list('modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_thetruth01.ogg', 'modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_iamthelast01.ogg')), 100)
	set_combat_mode(TRUE)

/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth/death(gibbed)
	. = ..()
	alert_sound_to_playing('modular_skyrat/master_files/sound/blackmesa/nihilanth/nihilanth_death01.ogg')
	new /obj/effect/singularity_creation(loc)
	message_admins("[src] has been defeated, a spacetime cascade will occur in 10 seconds.")
	addtimer(CALLBACK(src, .proc/endgame_shit),  10 SECONDS)

/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth/proc/endgame_shit()
	to_chat(world, span_danger("You feel as though a powerful force has been defeated..."))
	var/datum/round_event_control/resonance_cascade/event_to_start = new()
	event_to_start.runEvent()

/mob/living/simple_animal/hostile/blackmesa/xen/nihilanth/LoseAggro()
	. = ..()
	set_combat_mode(FALSE)

/datum/round_event_control/resonance_cascade
	name = "Portal Storm: Spacetime Cascade"
	typepath = /datum/round_event/portal_storm/resonance_cascade
	weight = 0
	max_occurrences = 0

/datum/round_event/portal_storm/resonance_cascade/announce(fake)
	set waitfor = 0
	sound_to_playing_players('modular_skyrat/master_files/sound/blackmesa/tc_12_portalsuck.ogg')
	sleep(40)
	priority_announce("GENERAL ALERT: Spacetime cascade detected; massive transdimentional rift inbound!", "Transdimentional Rift", ANNOUNCER_KLAXON)
	sleep(20)
	sound_to_playing_players('modular_skyrat/master_files/sound/blackmesa/tc_13_teleport.ogg')

/datum/round_event/portal_storm/resonance_cascade
	hostile_types = list(
		/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid = 30,
		/mob/living/simple_animal/hostile/blackmesa/xen/houndeye = 30,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab = 30
	)

///////////////////HECU SPAWNERS
/obj/effect/spawner/random/hecu_smg
	name = "HECU SMG drops"
	spawn_all_loot = TRUE
	loot = list(/obj/item/gun/ballistic/automatic/cfa_wildcat = 30,
				/obj/item/clothing/mask/gas/hecu2 = 20,
				/obj/item/clothing/head/helmet = 20,
				/obj/item/clothing/suit/armor/vest = 15,
				/obj/item/clothing/shoes/combat = 15)

/obj/effect/spawner/random/hecu_deagle
	name = "HECU Deagle drops"
	spawn_all_loot = TRUE
	loot = list(/obj/item/gun/ballistic/automatic/pistol/deagle = 30,
				/obj/item/clothing/mask/gas/hecu2 = 20,
				/obj/item/clothing/head/helmet = 20,
				/obj/item/clothing/suit/armor/vest = 15,
				/obj/item/clothing/shoes/combat = 15)

///////////////////HECU
/mob/living/simple_animal/hostile/blackmesa/hecu
	name = "HECU Grunt"
	desc = "I didn't sign on for this shit. Monsters, sure, but civilians? Who ordered this operation anyway?"
	icon = 'modular_skyrat/master_files/icons/mob/blackmesa.dmi'
	icon_state = "hecu_melee"
	icon_living = "hecu_melee"
	icon_dead = "hecu_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	speak_chance = 10
	speak = list("Stop right there!")
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 150
	health = 150
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	combat_mode = TRUE
	loot = list(/obj/item/melee/baton)
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 7.5
	faction = list(FACTION_HECU)
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1
	dodging = TRUE
	rapid_melee = 2
	footstep_type = FOOTSTEP_MOB_SHOE
	alert_sounds = list(
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert01.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert03.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert04.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert05.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert06.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert07.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert08.ogg',
		'modular_skyrat/master_files/sound/blackmesa/hecu/hg_alert10.ogg'
	)


/mob/living/simple_animal/hostile/blackmesa/hecu/ranged
	ranged = TRUE
	retreat_distance = 5
	minimum_distance = 5
	icon_state = "hecu_ranged"
	icon_living = "hecu_ranged"
	casingtype = /obj/item/ammo_casing/a50ae
	projectilesound = 'sound/weapons/gun/pistol/shot.ogg'
	loot = list(/obj/effect/gibspawner/human, /obj/effect/spawner/random/hecu_deagle)
	dodging = TRUE
	rapid_melee = 1

/mob/living/simple_animal/hostile/blackmesa/hecu/ranged/smg
	rapid = 3
	icon_state = "hecu_ranged_smg"
	icon_living = "hecu_ranged_smg"
	casingtype = /obj/item/ammo_casing/c32
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	loot = list(/obj/effect/gibspawner/human, /obj/effect/spawner/random/hecu_smg)

/mob/living/simple_animal/hostile/blackmesa/sec
	name = "Security Guard"
	desc = "About that beer I owe'd ya!"
	icon = 'modular_skyrat/master_files/icons/mob/blackmesa.dmi'
	icon_state = "security_guard_melee"
	icon_living = "security_guard_melee"
	icon_dead = "security_guard_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	speak_chance = 10
	speak = list("Hey, freeman! Over here!")
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 7
	melee_damage_upper = 7
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	loot = list(/obj/effect/gibspawner/human, /obj/item/clothing/suit/armor/vest/blueshirt)
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 7.5
	faction = list(FACTION_BLACKMESA)
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = TRUE
	combat_mode = TRUE
	dodging = TRUE
	rapid_melee = 2
	footstep_type = FOOTSTEP_MOB_SHOE
	alert_sounds = list(
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance01.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance02.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance02.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance03.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance04.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance05.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance06.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance07.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance08.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance09.ogg',
		'modular_skyrat/master_files/sound/blackmesa/security_guard/annoyance10.ogg'
	)


/mob/living/simple_animal/hostile/blackmesa/sec/ranged
	ranged = TRUE
	retreat_distance = 5
	minimum_distance = 5
	icon_state = "security_guard_ranged"
	icon_living = "security_guard_ranged"
	casingtype = /obj/item/ammo_casing/b9mm
	projectilesound = 'sound/weapons/gun/pistol/shot.ogg'
	loot = list(/obj/item/clothing/suit/armor/vest/blueshirt, /obj/item/gun/ballistic/automatic/pistol/g17/mesa)
	rapid_melee = 1

/obj/machinery/porta_turret/black_mesa
	use_power = IDLE_POWER_USE
	req_access = list(ACCESS_CENT_GENERAL)
	faction = list(FACTION_XEN, FACTION_BLACKMESA, FACTION_HECU)
	mode = TURRET_LETHAL
	uses_stored = FALSE
	max_integrity = 120
	base_icon_state = "syndie"
	lethal_projectile = /obj/projectile/beam/emitter
	lethal_projectile_sound = 'sound/weapons/laser.ogg'

/obj/machinery/porta_turret/black_mesa/assess_perp(mob/living/carbon/human/perp)
	return 10

/obj/machinery/porta_turret/black_mesa/setup(obj/item/gun/turret_gun)
	return

/obj/machinery/porta_turret/black_mesa/heavy
	name = "Heavy Defence Turret"
	max_integrity = 200
	lethal_projectile = /obj/projectile/beam/laser/heavylaser
	lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/effect/random_mob_placer
	name = "mob placer"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "mobspawner"
	var/list/possible_mobs = list(/mob/living/simple_animal/hostile/blackmesa/xen/headcrab)

/obj/effect/random_mob_placer/Initialize(mapload)
	. = ..()
	var/mob/picked_mob = pick(possible_mobs)
	new picked_mob(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/random_mob_placer/xen
	possible_mobs = list(
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab,
		/mob/living/simple_animal/hostile/blackmesa/xen/houndeye,
		/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid
	)

/obj/effect/mob_spawn/ghost_role/human/black_mesa
	name = "Research Facility Science Team"
	prompt_name = "a research facility scientist"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/science_team
	you_are_text = "You are a scientist in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within."
	flavour_text = "You are a scientist in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within."

/datum/outfit/science_team
	name = "Scientist"
	uniform = /obj/item/clothing/under/misc/hlscience
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/reagent_containers/glass/beaker)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/science_team

/datum/outfit/science_team/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/science_team
	assignment = "Science Team Scientist"
	trim_state = "trim_scientist"
	access = list(ACCESS_RND)

/obj/effect/mob_spawn/ghost_role/human/black_mesa/guard
	name = "Research Facility Security Guard"
	prompt_name = "a research facility guard"
	outfit = /datum/outfit/security_guard
	you_are_text = "You are a security guard in a top secret government facility. You blacked out. Now, you have woken up to the horrors that lay within. DO NOT TRY TO EXPLORE THE LEVEL. STAY AROUND YOUR AREA."

/obj/item/clothing/under/rank/security/peacekeeper/junior/sol/blackmesa
	name = "security guard uniform"
	desc = "About that beer I owe'd ya!"

/datum/outfit/security_guard
	name = "Security Guard"
	uniform = /obj/item/clothing/under/rank/security/peacekeeper/junior/sol/blackmesa
	head = /obj/item/clothing/head/helmet/blueshirt
	gloves = /obj/item/clothing/gloves/color/black
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/radio, /obj/item/gun/ballistic/automatic/pistol/g17/mesa, /obj/item/ammo_box/magazine/multi_sprite/g17)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/security_guard

/datum/outfit/security_guard/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_BLACKMESA

/datum/id_trim/security_guard
	assignment = "Security Guard"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_SEC_DOORS, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/effect/mob_spawn/ghost_role/human/black_mesa/hecu
	name = "HECU"
	prompt_name = "a tactical squad member"
	outfit = /datum/outfit/hecu
	you_are_text = "You are an elite tactical squad deployed into the research facility to contain the infestation. DO NOT TRY TO EXPLORE THE LEVEL. STAY AROUND YOUR AREA."

/obj/item/clothing/under/rank/security/officer/hecu
	name = "hecu jumpsuit"
	desc = "A tactical HECU fatigues for regular troops complete with USMC belt buckle." ///SIR YES SIR HOORAH
	icon = 'modular_skyrat/master_files/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/uniform.dmi'
	icon_state = "hecu_uniform"
	inhand_icon_state = "r_suit"
	uses_advanced_reskins = FALSE
	unique_reskin = null

///It looks fairly fitting for an "elite tacticool squad", so we'll just reuse it with the Expeditionary Corps' gear stats, and without that plasteel mention, until someone sprites/finds a better one. To make it fair.
/obj/item/clothing/suit/armor/vest/marine/hecu
	desc = "A set of the finest mass produced, stamped steel armor plates, containing an environmental protection unit for all-condition door kicking."
	icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/hecucloth.dmi'
	worn_icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/hecumob.dmi'
	icon_state = "hecu_vest"
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 40, BIO = 0, FIRE = 80, ACID = 100, WOUND = 30)

/obj/item/clothing/head/helmet/marine/hecu
	icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/hecucloth.dmi'
	worn_icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/hecumob.dmi'
	icon_state = "hecu_helm"
	clothing_flags = SNUG_FIT | PLASMAMAN_HELMET_EXEMPT
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 30, BIO = 0, FIRE = 80, ACID = 100, WOUND = 30)

/obj/item/storage/backpack/ert/odst/hecu
	name = "hecu backpack"

/datum/outfit/hecu
	name = "HECU Grunt"
	uniform = /obj/item/clothing/under/rank/security/officer/hecu
	head = /obj/item/clothing/head/helmet/marine/hecu
	mask = /obj/item/clothing/mask/balaclavaadjust
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/armor/vest/marine/hecu
	suit_store = /obj/item/gun/ballistic/automatic/m16
	belt = /obj/item/storage/belt/security/webbing
	ears = /obj/item/radio/headset
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/grenade/smokebomb
	r_pocket = /obj/item/binoculars
	back = /obj/item/storage/backpack/ert/odst/hecu
	backpack_contents = list(
		/obj/item/storage/box/survival/radio,
		/obj/item/ammo_box/magazine/m16 = 3,
		/obj/item/storage/firstaid/expeditionary,
		/obj/item/storage/box/hecu_rations,
		/obj/item/gun/ballistic/automatic/pistol/g17/mesa,
		/obj/item/ammo_box/magazine/multi_sprite/g17 = 2,
		/obj/item/knife/combat
	)
	id = /obj/item/card/id
	id_trim = /datum/id_trim/hecu

/datum/outfit/hecu/post_equip(mob/living/carbon/human/equipped_human, visualsOnly)
	. = ..()
	equipped_human.faction |= FACTION_HECU
	equipped_human.hairstyle = "Crewcut"
	equipped_human.hair_color = COLOR_ALMOST_BLACK
	equipped_human.facial_hairstyle = "Shaved"
	equipped_human.facial_hair_color = COLOR_ALMOST_BLACK
	equipped_human.update_hair()

/datum/id_trim/hecu
	assignment = "HECU Soldier"
	trim_state = "trim_securityofficer"
	access = list(ACCESS_SEC_DOORS, ACCESS_SECURITY, ACCESS_AWAY_SEC)

/obj/item/food/mre_course
	name = "undefined MRE course"
	desc = "Something you shouldn't see. But it's edible."
	icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/courses.dmi'
	icon_state = "main_course"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("crayon powder" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mre_course/main
	name = "MRE main course"
	desc = "Main course of the ancient military ration designed for ground troops. This one is NOTHING."
	tastes = list("strawberry" = 1, "vanilla" = 1, "chocolate" = 1)

/obj/item/food/mre_course/main/beans
	name = "MRE main course - Pork and Beans"
	desc = "Main course of the ancient military ration designed for ground troops. This one is pork and beans covered in some tomato sauce."
	tastes = list("beans" = 1, "pork" = 1, "tomato sauce" = 1)

/obj/item/food/mre_course/main/macaroni
	name = "MRE main course - Macaroni and Cheese"
	desc = "Main course of the ancient military ration designed for ground troops. This one is preboiled macaroni covered in some federal reserve cheese."
	tastes = list("cold macaroni" = 1, "bland cheese" = 1)

/obj/item/food/mre_course/main/rice
	name = "MRE main course - Rice and Beef"
	desc = "Main course of the ancient military ration designed for ground troops. This one is rice with beef, covered in gravy."
	tastes = list("dense rice" = 1, "bits of beef" = 1, "gravy" = 1)

/obj/item/food/mre_course/side
	name = "MRE side course"
	desc = "Side course of the ancient military ration designed for ground troops. This one is NOTHING."
	icon_state = "side_dish"

/obj/item/food/mre_course/side/bread
	name = "MRE side course - Cornbread"
	desc = "Side course of the ancient military ration designed for ground troops. This one is cornbread."
	tastes = list("cornbread" = 1)

/obj/item/food/mre_course/side/pie
	name = "MRE side course - Meat Pie"
	desc = "Side course of the ancient military ration designed for ground troops. This one is some meat pie."
	tastes = list("pie dough" = 1, "ground meat" = 1, "Texas" = 1)

/obj/item/food/mre_course/side/chicken
	name = "MRE side course - Sweet 'n Sour Chicken"
	desc = "Side course of the ancient military ration designed for ground troops. This one is some undefined chicken-looking meat covered in cheap reddish sauce."
	tastes = list("bits of chicken meat" = 1, "sweet and sour sauce" = 1, "salt" = 1)

/obj/item/food/mre_course/dessert
	name = "MRE dessert"
	desc = "Dessert of the ancient military ration designed for ground troops. This one is NOTHING."
	icon_state = "dessert"

/obj/item/food/mre_course/dessert/cookie
	name = "MRE dessert - Cookie"
	desc = "Dessert of the ancient military ration designed for ground troops. This one is a big dry cookie."
	tastes = list("dryness" = 1, "hard cookie" = 1, "chocolate chip" = 1)

/obj/item/food/mre_course/dessert/cake
	name = "MRE dessert - Apple Pie"
	desc = "Dessert of the ancient military ration designed for ground troops. This one is an amorphous apple pie."
	tastes = list("apple" = 1, "moist cake" = 1, "sugar" = 1)

/obj/item/food/mre_course/dessert/chocolate
	name = "MRE dessert - Dark Chocolate"
	desc = "Dessert of the ancient military ration designed for ground troops. This one is a dark bar of chocolate."
	tastes = list("vanilla" = 1, "artificial chocolate" = 1, "chemicals" = 1)

/obj/item/storage/box/hecu_rations
	name = "Meal, Ready-to-Eat"
	desc = "A box containing a few rations and some chewing gum, for keeping a starving crayon-eater going."
	icon = 'modular_skyrat/modules/awaymissions_skyrat/icons/mre_hecu.dmi'
	icon_state = "mre_package"
	illustration = null

/obj/item/storage/box/hecu_rations/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/box/hecu_rations/PopulateContents()
	var/main_course = pick(/obj/item/food/mre_course/main/beans, /obj/item/food/mre_course/main/macaroni, /obj/item/food/mre_course/main/rice)
	var/side_dish = pick(/obj/item/food/mre_course/side/bread, /obj/item/food/mre_course/side/pie, /obj/item/food/mre_course/side/chicken)
	var/dessert = pick(/obj/item/food/mre_course/dessert/cookie, /obj/item/food/mre_course/dessert/cake, /obj/item/food/mre_course/dessert/chocolate)
	new main_course(src)
	new side_dish(src)
	new dessert(src)
	new /obj/item/storage/box/gum(src)
	new /obj/item/food/spacers_sidekick(src)
