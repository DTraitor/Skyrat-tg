/*
	Necromorph Species Base. Parent to all Necromorph Varients.
*/
/datum/species/necromorph
	name = SPECIES_NECROMORPH
	id = SPECIES_NECROMORPH
	sexes = TRUE
	can_have_genitals = FALSE
	default_color = "#FFF"
	var/info_text = "You are a <span class='danger'>Vampire</span>. You will slowly but constantly lose blood if outside of a coffin. If inside a coffin, you will slowly heal. You may gain more blood by grabbing a live victim and using your drain ability."
	limbs_id = "slasher"
	limbs_icon = 'modular_skyrat/modules/necromorphs/icons/mob/necromorph/slasher.dmi'
	eyes_icon = 'modular_skyrat/modules/necromorphs/icons/mob/necromorph/slasher_enhanced_eyes.dmi'
	exotic_blood = /datum/reagent/copper
	reagent_flags = PROCESS_ORGANIC
	always_customizable = FALSE
	nojumpsuit = 1
	flavor_text = "Necromorphs are mutated corpses, reshaped into horrific new forms by a recombinant extraterrestrial infection derived from a genetic code etched into the skin of the Markers. The resulting creatures are extremely aggressive and will attack any uninfected organism on sight. The sole purpose of all Necromorphs is to acquire more bodies to convert and spread the infection. They are believed by some to be the heralds of humanity's ascension, but on a more practical level, they are the extremely dangerous result of exposure to the enigmatic devices known as the Markers."

	var/marker_spawnable = TRUE	//Set this to true to allow the marker to spawn this type of necro. Be sure to unset it on the enhanced version unless desired
	var/preference_settable = TRUE
	biomass = 80	//This var is defined for all species
	var/require_total_biomass = 0	//If set, this can only be spawned when total biomass is above this value
	var/biomass_reclamation	=	1	//The marker recovers cost*reclamation
	var/biomass_reclamation_time	=	8 MINUTES	//How long does it take for all of the reclaimed biomass to return to the marker? This is a pseudo respawn timer
	var/spawn_method = SPAWN_POINT	//What method of spawning from marker should be used? At a point or manual placement? check _defines/necromorph.dm
	var/major_vessel = TRUE	//If true, we can fill this mob from the necroqueue
	var/spawner_spawnable = FALSE	//If true, a nest can be upgraded to autospawn this unit
	//var/necroshop_item_type = /datum/necroshop_item //Give this a subtype if you want to have special behaviour for when this necromorph is spawned from the necroshop
	var/global_limit = 0	//0 = no limit
	var/ventcrawl = FALSE //Can this necromorph type ventcrawl?
	var/ventcrawl_time = 4.5 SECONDS
	//lasting_damage_factor = 0.2	//Necromorphs take lasting damage based on incoming hits

	//Single iconstates. These are somewhat of a hack
	var/single_icon = FALSE
	icon_template = 'modular_skyrat/modules/necromorphs/icons/mob/necromorph/48x48necros.dmi'
	var/icon_normal = "slasher_d"
	var/icon_lying = "slasher_d_lying"
	var/icon_dead = "slasher_d_dead"

	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks// What marks are left when walking

//	var/icon_template = 'icons/mob/human_races/species/template.dmi' // Used for mob icon generation for non-32x32 species.
	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.

	/*
		Necromorph customisation system
	*/
	var/list/variants			//Species variants included. This is an assoc list in the format: species_name = list(weight, patron)
		//If patron is true, this variant is not available by default
	var/list/outfits		//Outfits the mob can spawn with, weighted.

	var/can_vomit = TRUE		//Whether this mob can vomit, added to disable it on necromorphs

	locomotion_limbs = list(BP_L_LEG, BP_R_LEG)

	var/list/defensive_limbs = list(UPPERBODY = list(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND), //Arms and hands are used to shield the face and body
	LOWERBODY = list(BP_L_LEG, BP_R_LEG))	//Legs, but not feet, are used to guard the groin

/////////////////////////////////////////////////////////////////////////////
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
		HAIR,
		NO_UNDERWEAR,
		FACEHAIR
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOMETABOLISM,
		TRAIT_GENELESS,
		TRAIT_TOXIMMUNE,
		TRAIT_OXYIMMUNE,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID


/////////////////////////////////////////////////////////////////////////////
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'

	burnmod = 1.5 // Every 0.1% is 10% above the base.
	brutemod = 1.6
	coldmod = 1.2
	heatmod = 2
	siemens_coeff = 1.4 //Not more because some shocks will outright crit you, which is very unfun

	bodytemp_normal = (BODYTEMP_NORMAL + 70)
	bodytemp_heat_damage_limit = FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	bodytemp_cold_damage_limit = (T20C - 10)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

/////////////////////////////////////////////////////////////////////////////
////////////////////////// ORGANS FOR ALL SUBTYPES //////////////////////////
/////////////////////////////////////////////////////////////////////////////

	mutant_organs = list(
		/obj/item/organ/brain/necromorph,
		/obj/item/organ/eyes/night_vision/necromorph,
		/obj/item/organ/lungs/necromorph,
		/obj/item/organ/heart/necromorph,
		/obj/item/organ/liver/necromorph,
		/obj/item/organ/tongue/necromorph
	)
	mutanteyes = /obj/item/organ/eyes/night_vision
	mutanttongue = /obj/item/organ/tongue/zombie

	default_mutant_bodyparts = list(
		"tail" = "None",
		"snout" = "None",
		"ears" = "None",
		"legs" = "Normal Legs",
		"wings" = "None",
		"taur" = "None",
		"horns" = "None"
	)


	damage_overlay_type = "xeno"

/////////////////////////////////////////////////////////////////////////////

	bodypart_overides = list(
	BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/necromorph,\
	BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/necromorph,\
	BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph,\
	BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/necromorph,\
	BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/necromorph,\
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph
	)

	mutant_bodyparts = list(
	BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/necromorph,\
	BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/necromorph,\
	BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph,\
	BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/necromorph,\
	BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/necromorph,\
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph
	)


	//Audio
	step_volume = 60 //Necromorphs can't wear shoes, so their base footstep volumes are louder
	step_range = 1
	pain_audio_threshold = 0.10
	speech_chance = 100
/*
/datum/species/necromorph/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	// Missing Defaults in DNA? Randomize!
	. = ..()
	H.faction = FACTION_NECROMORPH
	SSnecromorph.major_vessels += H
*/

//Individual necromorphs are identified only by their species
/datum/species/necromorph/random_name(gender, unique, lastname)
	var/randname = "[src.name] [rand(0,999)]"
	return randname

/datum/species/necromorph/proc/setup_movement(var/mob/living/carbon/human/H)

/datum/species/necromorph/New(var/mob/living/carbon/human/H)
	.=..()
	H.faction = FACTION_NECROMORPH
	SSnecromorph.major_vessels += H
	//breathing_organ = null //This is autoset to lungs in the parent if they exist.
	//We want it to be unset but we stil want to have our useless lungs
/*


/datum/species/necromorph/onDestroy(var/mob/living/carbon/human/H)
	SSnecromorph.major_vessels -= H

/datum/species/necromorph/setup_interaction(var/mob/living/carbon/human/H)
	.=..()

*/
/*
/datum/species/necromorph/psychosis_vulnerable()
	return FALSE

/datum/species/necromorph/get_blood_name()
	return "ichor"

/datum/species/necromorph/get_icobase(var/mob/living/carbon/human/H)
	return icon_template //We don't need to duplicate the same dmi path twice

/datum/species/necromorph/add_inherent_verbs(mob/living/carbon/human/H)
	.=..()
	add_verb(H, list(/mob/proc/necro_evacuate, /mob/proc/prey_sightings, /datum/proc/help))
	//Ventcrawling necromorphs are handled here. Don't give this to non living mobs...
	if(ventcrawl && isliving(H))
		add_verb(H, list(/mob/living/proc/ventcrawl, /mob/living/proc/necro_burst_vent))
		//And if we want to set a custom ventcrawl delay....
		H.ventcrawl_time = (src.ventcrawl_time) ? src.ventcrawl_time : H.ventcrawl_time
	//H.verbs |= /mob/proc/message_unitologists
	make_scary(H)

/datum/species/necromorph/proc/make_scary(mob/living/carbon/human/H)
	//H.set_traumatic_sight(TRUE) //All necrmorphs are scary. Some are more scary than others though

//Add this necro as a vision node for the marker and signals
/datum/species/necromorph/setup_interaction(var/mob/living/carbon/human/H)
	.=..()
	GLOB.necrovision.add_source(H)


//We don't want to be suffering for the lack of most particular organs
/datum/species/necromorph/should_have_organ(var/query)
	if (query in list(BP_EYES))	//Expand this list as needed
		return ..()
	return FALSE


//Populate the initial health values
/datum/species/necromorph/create_organs(var/mob/living/carbon/human/H)
	.=..()
	if (!initial_health_values)
		initial_health_values = list()
		for (var/organ_tag in H.organs_by_name)
			var/obj/item/organ/external/E	= H.organs_by_name[organ_tag]
			initial_health_values[organ_tag] = E.max_damage

	if (biomass)
		add_massive_atom(H)


//Necromorphs die when they've taken enough total damage to all their limbs.
/datum/species/necromorph/handle_death_check(var/mob/living/carbon/human/H)

	var/damage = get_weighted_total_limb_damage(H)
	if (damage >= H.max_health)
		return TRUE

	return FALSE


/datum/species/necromorph/handle_death(var/mob/living/carbon/human/H)
	//We just died? Lets start getting absorbed by the marker
	if (!SSnecromorph.marker)	//Gotta have one
		return
	if (H.biomass)
		SSnecromorph.marker.add_biomass_source(H, H.biomass*biomass_reclamation, biomass_reclamation_time, /datum/biomass_source/reclaim)
		remove_massive_atom(H)
	GLOB.necrovision.remove_source(H)
	SSnecromorph.major_vessels -= H

//How much damage has this necromorph taken?
//We'll loop through each organ tag in the species' initial health values list, which should definitely be populated already, and try to get the organ for each
	//Any limb still attached, adds its current damage to the total
	//Any limb no longer attached (or stumped) adds its pre-cached max damage * dismemberment mult to the total
	//Any limb which is considered to be a torso part adds its damage, multiplied by the torso mult, to the total
	//The return list var is used for hud healthbars
/datum/species/necromorph/proc/get_weighted_total_limb_damage(var/mob/living/carbon/human/H, var/return_list)
	var/total = 0
	var/blocked = 0
	if (!initial_health_values)
		return 0 //Not populated? welp

	for (var/organ_tag in initial_health_values)
		var/obj/item/organ/external/E	= H.organs_by_name[organ_tag]
		var/subtotal = 0
		if (!E || E.is_stump())
			//Its not here!

			subtotal = initial_health_values[organ_tag] * dismember_mult
			blocked += subtotal
		else
			//Its here
			subtotal = E.damage

			//Is it a torso part?
			if ((E.organ_tag in BP_TORSO))
				subtotal *= torso_damage_mult


		//And now add to total
		total += subtotal

	var/lasting = H.getLastingDamage()
	blocked += lasting
	total += lasting

	if (return_list)
		return list("damage" = total, "blocked" = blocked)

	return total

//Individual necromorphs are identified only by their species
/datum/species/necromorph/get_random_name()
	return "[src.name] [rand(0,999)]"

// Used to update alien icons for aliens.
/datum/species/necromorph/handle_login_special(var/mob/living/carbon/human/H)
	.=..()
	H.set_necromorph(TRUE)
	to_chat(H, "You are a [name]. \n\
	[blurb]\n\
	\n\
	Check the Abilities tab, use the Help ability to find out what your controls and abilities do!")
	H.apply_customisation(H.client.prefs)



/datum/species/necromorph/can_autoheal(var/mob/living/carbon/human/H, var/dam_type, var/datum/wound/W)
	if (healing_factor > 0)
		return TRUE
	else
		return FALSE



/datum/species/necromorph/handle_post_spawn(var/mob/living/carbon/human/H)
	.=..()
	//Apply customisation with a null preference, this applies default settings
	if (!(HAS_TRANSFORMATION_MOVEMENT_HANDLER(H)))
		H.apply_customisation(null)
*/
