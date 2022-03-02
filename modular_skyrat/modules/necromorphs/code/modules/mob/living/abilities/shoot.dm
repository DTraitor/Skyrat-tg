#define SHOOT_STATUS_READY	0
#define	SHOOT_STATUS_PREFIRE	1
#define	SHOOT_STATUS_FIRING	2
#define	SHOOT_STATUS_COOLING	3
/*
	Generic Shoot Extension. Make subtypes for things which shouldn't share a cooldown
*/
/obj/effect/proc_holder/necro
	name = "Base Necro Ability"
	panel = "Abilities"
	desc = "Tasty"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	action_icon = 'icons/mob/actions/actions_clown.dmi'
	action_icon_state = "rustle"
	action_background_icon_state = "bg_fugu"
	base_action = /datum/action/cooldown/spell_like
	var/cooldown = 1 SECONDS

/obj/effect/proc_holder/necro/New(loc, ...)
	.=..()
	var/datum/action/cooldown/spell_like/_action = action
	_action.cooldown_time = cooldown

/obj/effect/proc_holder/necro/shoot
	name = "Shoot"
	desc = "Replace me (please!)"
	action_icon = 'icons/mob/actions/actions_clown.dmi'
	action_icon_state = "rustle"
	var/projectile_type
	var/base_accuracy
	var/list/dispersion
	var/total_shots
	var/windup_time
	var/fire_sound
	var/nomove = 0
	var/vector2/starting_pixel_offset

/*
	Vars expected:
	user: What/who is firing the projectiles
	target: What are projectiles being fired at
	projectile_type: What type of projectile we will spawn.
	accuracy: Base accuracy of the shot, default 100, optional
	dispersion: maximum deviation, one point = 9 degrees default 0, optional. Can also be a list of values
	num: How many projectiles to fire, default 1, optional
	windup: windup time before firing, default 0, optional. Note, no windup sound feature, play that in the caller
	fire sound: fire sound used when projectile is launched, optional. If not supplied, one will be taken from the projectile
	nomove: optional, default false. If true, the user can't move during windup. If a number, the user can't move during windup and for that long after firing
*/

/obj/effect/proc_holder/necro/shoot/Initialize(
		mapload,
		mob/living/new_owner,
		projectile_type, accuracy = 0,
		dispersion = 0, num = 1,
		windup_time = 0,
		fire_sound, nomove = FALSE,
		cooldown = 0,
		vector2/_starting_pixel_offset)
	.=..()
	src.projectile_type = projectile_type
	src.base_accuracy = accuracy
	src.dispersion = dispersion
	src.total_shots = num
	src.windup_time = windup_time
	src.fire_sound = fire_sound
	src.nomove = nomove
	src.cooldown = cooldown

	if (_starting_pixel_offset)
		starting_pixel_offset = _starting_pixel_offset

/obj/effect/proc_holder/necro/shoot/Click()
	if(!..())
		return
	var/message
	if(active)
		message = span_notice("You no longer prepare to shoot something.")
		remove_ranged_ability(message)
	else
		message = span_notice("You prepare to shoot something. <B>Left-click your target to shoot!</B>")
		add_ranged_ability(usr, message, TRUE)
	return TRUE

/obj/effect/proc_holder/necro/shoot/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return

	if(ranged_ability_user.incapacitated())
		remove_ranged_ability()
		return

	//First of all, if nomove is set, lets paralyse the user
	if(nomove)
		var/stoptime = windup_time
		if(isnum(nomove))
			stoptime += nomove

		if(stoptime)
			ranged_ability_user.set_move_cooldown(stoptime) // Need to figure out how to set movement cooldown

	//Now lets windup the shot(s)
	if(windup_time)

		windup_animation()

	fire_animation()

	//And start the main event
	var/target_zone = ranged_ability_user.zone_selected
	var/turf/targloc = get_turf(target)
	for(var/shot_num in 1 to total_shots)
		var/obj/projectile/P = new projectile_type(ranged_ability_user.loc)
		if(starting_pixel_offset)
			P.pixel_x += starting_pixel_offset.x
			P.pixel_y += starting_pixel_offset.y
		P.accuracy += base_accuracy // How to to implement this two?
		P.dispersion = get_dispersion(shot_num) // How to to implement this two?
		P.firer = ranged_ability_user
		P.def_zone = target_zone
		P.fired_from = ranged_ability_user

		if(QDELETED(target))
			P.fire(, targloc) // How does it work? How do I calculate angle?
		else
			P.fire(, target) // How does it work? How do I calculate angle?

		if(fire_sound)
			if(islist(fire_sound))
				playsound(ranged_ability_user, pick(fire_sound), VOLUME_MID, 1)
			else
				playsound(ranged_ability_user, fire_sound, VOLUME_MID, 1)
	remove_ranged_ability()
	return TRUE

/obj/effect/proc_holder/necro/shoot/on_lose(mob/living/carbon/user)
	remove_ranged_ability()

//If its a single number, just return that
/obj/effect/proc_holder/necro/shoot/proc/get_dispersion(shot_num)
	if (isnum(dispersion))
		return dispersion

	if (islist(dispersion))
		return dispersion[shot_num]

/obj/effect/proc_holder/necro/shoot/proc/windup_animation()
	sleep(windup_time)

/obj/effect/proc_holder/necro/shoot/proc/fire_animation()
	return
