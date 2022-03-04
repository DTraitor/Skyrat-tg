/datum/action/cooldown/necro/Activate(atom/target)
	StartCooldown(cooldown_time)

/datum/action/cooldown/necro/shout
	name = "Shout"
	desc = "Lay a cluster of eggs, which will soon grow into a normal spider."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_eggs"
	cooldown_time = 8 SECONDS
	var/sound_type = SOUND_SHOUT
	var/do_stun = FALSE

/datum/action/cooldown/necro/shout/Activate()
	.=..()
	var/mob/living/living = owner
	if(living.play_species_audio(living, sound_type, VOLUME_HIGH, 1, 2))
		if(do_stun)
			living.Stun(1)
		living.shake_animation(40)
		new /obj/effect/expanding_circle(living.loc, 2, 3 SECONDS)	//Visual effect
		for (var/mob/M in range(8, living))
			var/distance = get_dist(living, M)
			var/intensity = 5 - (distance * 0.3)
			var/duration = (7 - (distance * 0.5)) SECONDS
			shake_camera(M, duration, intensity)
			//TODO in future: Add psychosis damage here for non-necros who hear the scream

/datum/action/cooldown/necro/shout/long
	name = "Scream"
	desc = "Lay a cluster of eggs, which will soon grow into a normal spider."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "lay_eggs"
	sound_type = SOUND_SHOUT_LONG
	do_stun = TRUE
