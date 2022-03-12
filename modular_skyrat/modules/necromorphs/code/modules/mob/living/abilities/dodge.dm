/datum/action/cooldown/necro/dodge
	name = "Dodge"
	cooldown_time = 5 SECONDS
	shared_cooldown = "necro_charge"
	var/block_movement = FALSE
	var/dodge_range = 1
	var/movement_delay = 1.25

/datum/action/cooldown/necro/dodge/New(Target, range, move_delay)
	if(range)
		dodge_range = range
	if(movement_delay)
		movement_delay = move_delay
	.=..()

/datum/action/cooldown/necro/dodge/Activate()
	.=..()
	var/list/possible_turfs = RANGE_TURFS(dodge_range, owner)
	possible_turfs -= get_turf(owner)
	possible_turfs -= get_step(owner, owner.dir)
	possible_turfs -= get_step(owner, DIRFLIP(owner.dir))

	var/turf/target
	while(possible_turfs.len) //Using while() instead of for() to ensure target turf is randomised
		target = pick(possible_turfs)
		if(!target.is_blocked_turf())
			break
		possible_turfs -= target
		target = null
	if(target)
		var/time_to_hit = min(get_dist(owner, target), dodge_range) * movement_delay
		var/datum/move_loop/new_loop = SSmove_manager.home_onto(owner, target, delay = movement_delay, timeout = time_to_hit, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
		if(!new_loop)
			return
		block_movement = TRUE
		RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, .proc/on_move)
		RegisterSignal(new_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, .proc/pre_move)
		RegisterSignal(new_loop, COMSIG_MOVELOOP_POSTPROCESS, .proc/post_move)
		RegisterSignal(new_loop, COMSIG_PARENT_QDELETING, .proc/RemoveMovementBlock)
		owner.visible_message(span_danger("[owner] nimbly dodges to the side!"))
		//Randomly selected sound
		var/sound_type = pickweight(list(SOUND_SPEECH = 6, SOUND_ATTACK  = 2, SOUND_PAIN = 1.5, SOUND_SHOUT = 1))
		owner.play_species_audio(owner, sound_type, VOLUME_QUIET, 1, -1)
	else
		to_chat(owner, span_notice("Couldn't find valid dodge location!"))

/datum/action/cooldown/necro/dodge/proc/on_move()
	SIGNAL_HANDLER
	if(block_movement)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/action/cooldown/necro/dodge/proc/RemoveMovementBlock()
	SIGNAL_HANDLER
	block_movement = FALSE
	owner.set_dir_on_move = TRUE
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)

/datum/action/cooldown/necro/dodge/proc/pre_move()
	SIGNAL_HANDLER
	block_movement = FALSE
	owner.set_dir_on_move = FALSE

/datum/action/cooldown/necro/dodge/proc/post_move()
	SIGNAL_HANDLER
	block_movement = TRUE
	owner.set_dir_on_move = TRUE
