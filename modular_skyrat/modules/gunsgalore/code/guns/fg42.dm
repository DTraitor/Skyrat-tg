/obj/item/gun/ballistic/automatic/fg42
	name = "\improper FG-42"
	desc = "A German paratrooper rifle designed to be used at the very least, five-hundred and fifty years ago. It's most likely reproduction, and you should be concerned more than excited to have this in your hands."
	icon = 'modular_skyrat/modules/gunsgalore/icons/guns/gunsgalore_guns.dmi'
	icon_state = "fg42"
	lefthand_file = 'modular_skyrat/modules/gunsgalore/icons/guns/gunsgalore_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/gunsgalore/icons/guns/gunsgalore_righthand.dmi'
	inhand_icon_state = "fg42"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/fg42
	can_suppress = FALSE
	burst_size = 2
	spread = 0
	fire_delay = 2
	worn_icon = 'modular_skyrat/modules/gunsgalore/icons/guns/gunsgalore_back.dmi'
	worn_icon_state = "fg42"
	fire_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/fire/fg42_fire.ogg'
	alt_icons = TRUE
	realistic = TRUE
	zoomable = TRUE
	rack_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/interact/batrifle_cock.ogg'
	load_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/interact/batrifle_magin.ogg'
	load_empty_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/interact/batrifle_magin.ogg'
	eject_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/interact/batrifle_magout.ogg'
	eject_empty_sound = 'modular_skyrat/modules/gunsgalore/sound/guns/interact/batrifle_magout.ogg'

/obj/item/ammo_box/magazine/fg42
	name = "fg42 magazine (7.92×57mm)"
	icon = 'modular_skyrat/modules/gunsgalore/icons/guns/gunsgalore_items.dmi'
	icon_state = "fg42"
	ammo_type = /obj/item/ammo_casing/realistic/a792x57
	caliber = "a792x57"
	max_ammo = 20
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/fg42/modern
	name = "\improper FG-42 MK. VII"
	desc = "An absolute disgrace to any sane person's eyes, this is a cheap reproduction of an extremely old German paratrooper rifle filled to the brim with aftermarket parts, some of them shouldn't even be in there. Louis Stange is rolling in their grave."
	icon_state = "fg42_modern"
	inhand_icon_state = "fg42"
	worn_icon_state = "fg42"
	burst_size = 3
	fire_delay = 1
