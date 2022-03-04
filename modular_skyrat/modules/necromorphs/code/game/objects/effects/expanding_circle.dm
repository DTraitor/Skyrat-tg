/obj/effect/expanding_circle
	alpha = 100
	icon = 'icons/effects/effects_256.dmi'
	icon_state = "circle"
	pixel_x = -112
	pixel_y = -112
	var/lifespan
	var/expansion_rate

/obj/effect/expanding_circle/Initialize(mapload, _expansion_rate = 2, _lifespan = 2 SECONDS, _color = "#ffffff")
	lifespan = _lifespan
	expansion_rate = _expansion_rate //What scale multiplier to gain per second
	color = _color
	.=..()
	transform = transform.Scale(0.01)//Start off tiny
	var/matrix/M = new
	animate(src, transform = M.Scale(1 + (expansion_rate * (lifespan*0.1))), alpha = 0, time = lifespan)
	QDEL_IN(src, lifespan)
