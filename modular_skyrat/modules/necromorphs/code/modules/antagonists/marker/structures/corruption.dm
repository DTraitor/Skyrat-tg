GLOBAL_LIST_INIT(valid_corruptions, subtypesof(/datum/corruption))

/datum/corruption
	var/name
	var/description
	var/color = COLOR_MARKER_RED
	/// The color that stuff like healing effects and the overmind camera gets
	var/complementary_color = COLOR_BLACK
	/// A short description of the power and its effects
	var/shortdesc = null
	/// Any long, marker-tile specific effects
	var/effectdesc = null
	/// Short descriptor of what the strain does damage-wise, generally seen in the reroll menu
	var/analyzerdescdamage = "Unknown. Report this bug to a coder, or just adminhelp."
	/// Short descriptor of what the strain does in general, generally seen in the reroll menu
	var/analyzerdesceffect
	/// Markerbernaut attack verb
	var/markerbernaut_message = "slams"
	/// Message sent to any mob hit by the marker
	var/message = "The marker strikes you"
	/// Gets added onto 'message' if the mob stuck is of type living
	var/message_living = null
	/// Stores world.time to figure out when to next give resources
	var/resource_delay = 0
	/// For marker-mobs and extinguishing-based effects
	var/fire_based = FALSE
	var/mob/camera/marker/overmind
	/// The amount of health regenned on core_process
	var/base_core_regen = MARKER_CORE_HP_REGEN
	/// The amount of points gained on core_process
	var/point_rate = MARKER_BASE_POINT_RATE

	// Various vars that strains can buff the marker with
	/// HP regen bonus added by strain
	var/core_regen_bonus = 2
	/// resource point bonus added by strain
	var/point_rate_bonus = 2

	/// Adds to claim, pulse, and expand range
	var/core_range_bonus = 5
	/// The core can sustain this many extra spores with this strain
	var/core_spore_bonus = 5
	/// Extra range up to which the core reinforces markers
	var/core_strong_reinforcement_range_bonus = 5
	/// Extra range up to which the core reinforces markers into reflectors
	var/core_reflector_reinforcement_range_bonus = 5

	/// Adds to claim, pulse, and expand range
	var/node_range_bonus = 2
	/// Nodes can sustain this any extra spores with this strain
	var/node_spore_bonus = 2
	/// Extra range up to which the node reinforces markers
	var/node_strong_reinforcement_range_bonus = 2
	/// Extra range up to which the node reinforces markers into reflectors
	var/node_reflector_reinforcement_range_bonus = 2

	/// Extra spores produced by factories with this strain
	var/factory_spore_bonus = 3

	/// Multiplies the max and current health of every marker with this value upon selecting this strain.
	var/max_structure_health_multiplier = 1
	/// Multiplies the max and current health of every mob with this value upon selecting this strain.
	var/max_mob_health_multiplier = 1

	/// Makes markerbernauts inject a bonus amount of reagents, making their attacks more powerful
	var/markerbernaut_reagentatk_bonus = 0


/datum/corruption/corruption // Blobs that mess with reagents, all "legacy" ones // what do you mean "legacy" you never added an alternative
	var/datum/reagent/reagent

/datum/corruption/New(mob/camera/marker/new_overmind)
	if (!istype(new_overmind))
		stack_trace("corruption created without overmind")
	overmind = new_overmind

/datum/corruption/Destroy()
	overmind = null
	return ..()

/datum/corruption/proc/on_gain()
	overmind.color = complementary_color

	if(overmind.marker_core)
		overmind.marker_core.max_spores += core_spore_bonus
		overmind.marker_core.claim_range += core_range_bonus
		overmind.marker_core.pulse_range += core_range_bonus
		overmind.marker_core.expand_range += core_range_bonus
		overmind.marker_core.strong_reinforce_range += core_strong_reinforcement_range_bonus
		overmind.marker_core.reflector_reinforce_range += core_reflector_reinforcement_range_bonus

	for(var/obj/structure/marker/special/node/N as anything in overmind.node_markers)
		N.max_spores += node_spore_bonus
		N.claim_range += node_range_bonus
		N.pulse_range += node_range_bonus
		N.expand_range += node_range_bonus
		N.strong_reinforce_range += node_strong_reinforcement_range_bonus
		N.reflector_reinforce_range += node_reflector_reinforcement_range_bonus

	for(var/obj/structure/marker/special/factory/F as anything in overmind.factory_markers)
		F.max_spores += factory_spore_bonus

	for(var/obj/structure/marker/B as anything in overmind.all_markers)
		B.modify_max_integrity(B.max_integrity * max_structure_health_multiplier)
		B.update_appearance()

	for(var/mob/living/simple_animal/hostile/necromorph/BM as anything in overmind.marker_mobs)
		BM.maxHealth *= max_mob_health_multiplier
		BM.health *= max_mob_health_multiplier
		BM.update_icons() //If it's getting a new strain, tell it what it does!
		to_chat(BM, "Your overmind's marker strain is now: <b><font color=\"[color]\">[name]</b></font>!")
		to_chat(BM, "The <b><font color=\"[color]\">[name]</b></font> strain [shortdesc ? "[shortdesc]" : "[description]"]")

/datum/corruption/proc/on_lose()
	if(overmind.marker_core)
		overmind.marker_core.max_spores -= core_spore_bonus
		overmind.marker_core.claim_range -= core_range_bonus
		overmind.marker_core.pulse_range -= core_range_bonus
		overmind.marker_core.expand_range -= core_range_bonus
		overmind.marker_core.strong_reinforce_range -= core_strong_reinforcement_range_bonus
		overmind.marker_core.reflector_reinforce_range -= core_reflector_reinforcement_range_bonus

	for(var/obj/structure/marker/special/node/N as anything in overmind.node_markers)
		N.max_spores -= node_spore_bonus
		N.claim_range -= node_range_bonus
		N.pulse_range -= node_range_bonus
		N.expand_range -= node_range_bonus
		N.strong_reinforce_range -= node_strong_reinforcement_range_bonus
		N.reflector_reinforce_range -= node_reflector_reinforcement_range_bonus

	for(var/obj/structure/marker/special/factory/F as anything in overmind.factory_markers)
		F.max_spores -= factory_spore_bonus

	for(var/obj/structure/marker/B as anything in overmind.all_markers)
		B.modify_max_integrity(B.max_integrity / max_structure_health_multiplier)

	for(var/mob/living/simple_animal/hostile/necromorph/BM as anything in overmind.marker_mobs)
		BM.maxHealth /= max_mob_health_multiplier
		BM.health /= max_mob_health_multiplier


/datum/corruption/proc/on_sporedeath(mob/living/spore)

/datum/corruption/proc/send_message(mob/living/M)
	var/totalmessage = message
	if(message_living && !issilicon(M))
		totalmessage += message_living
	totalmessage += "!"
	to_chat(M, span_userdanger("[totalmessage]"))

/datum/corruption/proc/core_process()
	if(resource_delay <= world.time)
		resource_delay = world.time + 10 // 1 second
		overmind.add_points(point_rate+point_rate_bonus)
	overmind.marker_core.repair_damage(base_core_regen + core_regen_bonus)

/datum/corruption/proc/attack_living(mob/living/L, list/nearby_markers) // When the marker attacks people
	send_message(L)

/datum/corruption/proc/markerbernaut_attack(mob/living/L, marker) // When this marker's markerbernaut attacks people

/datum/corruption/proc/damage_reaction(obj/structure/marker/B, damage, damage_type, damage_flag, coefficient = 1) //when the marker takes damage, do this
	return coefficient*damage

/datum/corruption/proc/death_reaction(obj/structure/marker/B, damage_flag, coefficient = 1) //when a marker dies, do this
	return

/datum/corruption/proc/expand_reaction(obj/structure/marker/B, obj/structure/marker/newB, turf/T, mob/camera/marker/O, coefficient = 1) //when the marker expands, do this
	return

/datum/corruption/proc/tesla_reaction(obj/structure/marker/B, power, coefficient = 1) //when the marker is hit by a tesla bolt, do this
	return TRUE //return 0 to ignore damage

/datum/corruption/proc/extinguish_reaction(obj/structure/marker/B, coefficient = 1) //when the marker is hit with water, do this
	return

/datum/corruption/proc/emp_reaction(obj/structure/marker/B, severity, coefficient = 1) //when the marker is hit with an emp, do this
	return

/datum/corruption/proc/examine(mob/user)
	return list("<b>Progress to Critical Mass:</b> [span_notice("[overmind.markers_legit.len]/[overmind.markerwincount].")]")
