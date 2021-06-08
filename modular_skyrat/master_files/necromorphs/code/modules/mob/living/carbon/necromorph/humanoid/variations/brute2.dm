/mob/living/carbon/necromorph/humanoid/brute2
	name = "Brute 2" //SPECIES_NECROMORPH_BRUTE
	icon = 'modular_skyrat/modules/necromorphs/icons/mob/necromorph/brute.dmi'
	//status_flags = CANUNCONSCIOUS|CANPUSH|NOPAIN
	maxHealth = 400
	health = 450
	icon_state = "brute-d"
	//icon_living = "brute-d"
	//icon_lying = "brute-d-dead"//Temporary icon so its not invisible lying down
	//icon_dead = "brute-d-dead"
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //above most mobs, but below speechbubbles
	melee_damage_lower = 30
	melee_damage_upper = 40
	see_in_dark = 8
	pixel_x = -16
	base_pixel_x = -16
	//biomass = 350
	pressure_resistance = 200 //Because big, stompy xenos should not be blown around like paper.
	butcher_results = list(/obj/item/food/meat/slab/xeno = 20, /obj/item/stack/sheet/animalhide/xeno = 3)

/mob/living/carbon/alien/humanoid/drone/Initialize()
	AddAbility(new/obj/effect/proc_holder/alien/evolve(null))
	. = ..()

/mob/living/carbon/alien/humanoid/drone/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel/large
	internal_organs += new /obj/item/organ/alien/resinspinner
	internal_organs += new /obj/item/organ/alien/acid
	..()
