/mob/living/simple_animal/hostile/necromorph/necrobrute
	name = "brute"
	real_name = "brute"
	desc = "Holy shit, what the fuck is that thing?!"
	speak_emote = list("says with one of its faces")
	emote_hear = list("says with one of its faces")
	icon = 'modular_skyrat/modules/necromorphs/icons/mob/necromorph/brute.dmi'
	icon_state = "brute-d"
	icon_living = "brute-d"
	icon_dead = "brute-d-cut"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC
	mob_size = MOB_SIZE_LARGE
	speed = 1
	//a_intent = "harm"
	stop_automated_movement = 1
	status_flags = CANPUSH
	//ventcrawler = 2
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxHealth = 1000 //Very durable
	health = 1000
	healable = 0
	environment_smash = 15
	melee_damage_lower = 50
	melee_damage_upper = 90
//	see_in_dark = 8
//	see_invisible = SEE_INVISIBLE_MINIMUM
	wander = 1
	attack_verb_continuous = "rips into"
	attack_verb_simple = "rip into"
	attack_sound = 'modular_skyrat/modules/necromorphs/sound/effects/creatures/necromorph/brute/brute_attack_1.ogg'
	deathsound = 'modular_skyrat/modules/necromorphs/sound/effects/creatures/necromorph/brute/brute_death.ogg'
	deathmessage = "lets out a waning scream as it falls, twitching, to the floor."
	next_move_modifier = 0.5 //Faster attacks
	butcher_results = list(/obj/item/food/meat/slab/human = 15) //It's a pretty big dude. Actually killing one is a feat.
	gold_core_spawnable = 0 //Should stay exclusive to changelings tbh, otherwise makes it much less significant to sight one


