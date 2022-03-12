//TODO:
// - Move traits to proper file
// - Add buffs to owner and mobs in effect
#define TRAIT_NECRO_TAUNT_SOURCE "necro_taunt_source"
#define TRAIT_NECRO_TAUNT "necro_taunt"
/datum/action/cooldown/necro/active/taunt
	name = "Taunt"
	var/time_without_enemy = 0
	var/max_time_without_enemy = 6 SECONDS
	var/list/necromorphs_taunt = list()

/datum/action/cooldown/necro/active/taunt/Destroy()
	CooldownEnd()
	.=..()

/datum/action/cooldown/necro/active/taunt/Activate(atom/target)
	var/mob/living/holder = owner
	if(holder.body_position != LYING_DOWN)
		.=..()
		holder.add_filter("hunter_taunt", 1, list("type" = "outline", "color" = "#ff00007e", "size" = 1))
		RegisterSignal(holder, COMSIG_LIVING_UPDATED_RESTING, .proc/on_rest)
		ADD_TRAIT(holder, TRAIT_NECRO_TAUNT_SOURCE, "taunt_ability")
		//Add buffs to owner here
	else
		holder.balloon_alert(holder, "you should stand up to taunt")

/datum/action/cooldown/necro/active/taunt/proc/on_rest(datum/datum, resting)
	if(resting)
		owner.balloon_alert(owner, span_danger("You are a crumpled heap on the floor, taunt has ended")) // Message from DS13 code
		CooldownEnd()

/datum/action/cooldown/necro/active/taunt/CooldownEnd()
	.=..()
	if(.)
		for(var/mob/mob as anything in necromorphs_taunt)
			REMOVE_TRAIT(mob, TRAIT_NECRO_TAUNT, "taunt_ability")
			//Remove buffs
		necromorphs_taunt.Cut()
		owner.remove_filter("hunter_taunt")
		UnregisterSignal(owner, list(COMSIG_LIVING_UPDATED_RESTING))
		REMOVE_TRAIT(owner, TRAIT_NECRO_TAUNT_SOURCE, "taunt_ability")
		//Remove buffs from owner here

/datum/action/cooldown/necro/active/taunt/process(delta_time)
	.=..()
	if(active)
		var/list/mobs = view(10, owner)
		var/enemies_in_view = FALSE
		var/list/necromorphs = list()
		for(var/mob/mob in mobs)
			if(mob.faction != owner.faction)
				enemies_in_view = TRUE
			else
				if(mob.is_necromorph())
					necromorphs += mob
		if(!enemies_in_view)
			time_without_enemy += 0.2 SECONDS * delta_time
			if(time_without_enemy >= max_time_without_enemy)
				owner.balloon_alert(owner, span_danger("There are no more enemies in sight, taunt has ended"))
				CooldownEnd()
		else
			time_without_enemy = 0
			for(var/mob/mob as anything in necromorphs_taunt)
				if(!(mob in necromorphs))
					necromorphs -= mob
					REMOVE_TRAIT(mob, TRAIT_NECRO_TAUNT, "taunt_ability")
					//Remove buffs

			for(var/mob/mob as anything in necromorphs)
				if(HAS_TRAIT(mob, TRAIT_NECRO_TAUNT) || HAS_TRAIT(mob, TRAIT_NECRO_TAUNT_SOURCE))
					continue

				ADD_TRAIT(mob, TRAIT_NECRO_TAUNT, "taunt_ability")
				//Add buffs here
