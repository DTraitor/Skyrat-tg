/*
	Extension statmod system:
	To prevent cumulative math errors, extensions must use this system to modify any commonly shared attributes on a mob. This currently includes:

	To set a mod, just add DEFINE = value to the statmods list on the extension.
	If you change the contents of that list during runtime, call unregister_statmods before the change, then register_statmods after

	Name:								Define:									Expected Value
	Movespeed (additive)				STATMOD_MOVESPEED_ADDITIVE				A percentage value, 0=no change, 1 = +100%, etc. Negative allowed
	Movespeed (multiplicative)			STATMOD_MOVESPEED_MULTIPLICATIVE		A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Incoming Damage						STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE	A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Ranged Accuracy						STATMOD_RANGED_ACCURACY					A flat number of percentage points
	Vision Range						STATMOD_VIEW_RANGE						An integer number of tiles to add/remove from vision range
	Evasion								STATMOD_EVASION							An number of percentage points which will be additively added to evasion, negative allowed
	Scale								STATMOD_SCALE							A percentage value, 0=no change, 1 = +100%, etc. Negative allowed
	Max Health							STATMOD_HEALTH							A flat value which is added or removed
	Conversion Compatibility			STATMOD_CONVERSION_COMPATIBILITY		A flat value which is added or removed
*/



//This list is in the following format:
//Define = update_proc
GLOBAL_LIST_INIT(statmod_update_procs, list(
STATMOD_MOVESPEED_ADDITIVE = /datum/proc/update_movespeed_factor,
STATMOD_MOVESPEED_MULTIPLICATIVE = /datum/proc/update_movespeed_factor,
STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = /datum/proc/update_incoming_damage_factor,
STATMOD_RANGED_ACCURACY = /datum/proc/update_ranged_accuracy_factor,
STATMOD_ATTACK_SPEED = /datum/proc/update_attack_speed,
STATMOD_EVASION = /datum/proc/update_evasion,
STATMOD_VIEW_RANGE = /datum/proc/update_vision_range,
STATMOD_SCALE = /datum/proc/update_scale,
STATMOD_HEALTH = /datum/proc/update_max_health,
//Conversion compatibility doesn't get an entry here, its only used by infector conversions
))

/datum/component/statmods
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/statmods

/datum/component/statmods/Initialize(...)
	.=..()
	RegisterSignal(parent, COMSIG_REGISTER_STATS, ./proc/register_statmods)
	RegisterSignal(parent, COMSIG_UNREGISTER_STATS, ./proc/unregister_statmods)

/datum/component/statmods/proc/register_statmods(list/_statmods)
	for(var/modtype in _statmods)
		LAZYADDASSOC(statmods, modtype, _statmods[modtype])
		call(parent, GLOB.statmod_update_procs[modtype])()

/datum/component/statmods/proc/unregister_statmods(list/_statmods)
	for(var/modtype in _statmods)
		LAZYREMOVEASSOC(statmods, modtype, _statmods[modtype])
		call(parent, GLOB.statmod_update_procs[modtype])()

//Trigger all relevant update procs without changing registration
/datum/component/statmods/proc/update_statmods()
	for(var/modtype in statmods)
		call(parent, GLOB.statmod_update_procs[modtype])()

/datum/component/statmods/proc/get_statmod(var/modtype)
	return LAZYACCESS(statmods, modtype)


/*
	Movespeed
*/
/datum/proc/update_movespeed_factor()

/mob/update_movespeed_factor()
	move_speed_factor = 1

	//We add the result of each additive modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_ADDITIVE))
		move_speed_factor += E.get_statmod(STATMOD_MOVESPEED_ADDITIVE)

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_MULTIPLICATIVE))
		move_speed_factor *= E.get_statmod(STATMOD_MOVESPEED_MULTIPLICATIVE)



/*
	Incoming Damage
*/
//Additive modifiers first, then multiplicative
/datum/proc/update_incoming_damage_factor()

/mob/living/update_incoming_damage_factor()
	incoming_damage_mult = 1

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE))
		incoming_damage_mult *= E.get_statmod(STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE)



/*
	Ranged Accuracy
*/
/datum/proc/update_ranged_accuracy_factor()

/mob/living/update_ranged_accuracy_factor()
	ranged_accuracy_modifier = 0

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_RANGED_ACCURACY))
		ranged_accuracy_modifier += E.get_statmod(STATMOD_RANGED_ACCURACY)


/*
	attackspeed
*/
/datum/proc/update_attack_speed()

/mob/living/update_attack_speed()
	attack_speed_factor = 1

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_ATTACK_SPEED))
		attack_speed_factor += E.get_statmod(STATMOD_ATTACK_SPEED)



/*
	Evasion
*/
/datum/proc/update_evasion()

/mob/living/update_evasion()
	evasion = get_base_evasion()

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_EVASION))
		evasion += E.get_statmod(STATMOD_EVASION)



/datum/proc/get_base_evasion()
	return 0

/mob/living/get_base_evasion()
	return initial(evasion)


/mob/living/carbon/human/get_base_evasion()
	return species.evasion





/*
	Vision Range
*/
/datum/proc/update_vision_range()

/datum/proc/get_base_view_range()
	return world.view

/mob/living/get_base_view_range()
	if (eyeobj)
		return eyeobj.get_base_view_range()
	return initial(view_range)

/mob/dead/observer/eye/get_base_view_range()
	return initial(view_range)

/mob/living/carbon/human/get_base_view_range()
	if (eyeobj)
		return eyeobj.get_base_view_range()
	return species.view_range


/mob/update_vision_range()
	var/range = get_base_view_range()

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_VIEW_RANGE))
		range += E.get_statmod(STATMOD_VIEW_RANGE)

	//Vision range can't go below 1
	range = clamp(range, 1, INFINITY)

	view_range = range
	if (client)
		client.change_view(view_range)




/*
	Scale

	Controls the visible sprite size of the thing.
*/

/datum/proc/update_scale()
	return

//The speed var controls how fast we visibly transition scale, it is in cubic volume units per second
/atom/update_scale(var/speed = 0.3)
	var/old_scale = default_scale
	default_scale = get_base_scale()
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_SCALE))
		default_scale += E.get_statmod(STATMOD_SCALE)

	//We're going to do a smooth transition to the new scale

	//Lets get the difference in the volume between these shapes
	var/volume_difference = abs(default_scale**3 - old_scale**3)
	var/time_required	=	(volume_difference / speed)	SECONDS	//This define converts it to deciseconds

	//Do the animation
	animate_to_default(time_required)

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		spawn(time_required)
			H.update_icons()	//This will adjust pixel offsets to fit our new size

/datum/proc/get_base_scale()

/atom/get_base_scale()
	return 1.0




/*
	Health:
	The max health of this mob, how much damage it can take before dying

	Currently only meaningful for necromorphs and animals. Won't do much for non-necro humans because brainmed
*/

/datum/proc/update_max_health()
	return

/mob/living/update_max_health()
	max_health = get_base_health()
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_HEALTH))
		max_health += E.get_statmod(STATMOD_HEALTH)

	updatehealth()

/datum/proc/get_base_health()

/mob/living/get_base_health()
	return max(initial(health), initial(max_health))

/mob/living/carbon/human/get_base_health()
	return species.total_health


