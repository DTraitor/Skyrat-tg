//Recursive function to find the atom on a turf which we're nested inside
/atom/proc/get_toplevel_atom()
	var/atom/A = src
	while(A.loc && !(isturf(A.loc)))
		A = A.loc

	return A

/turf/get_toplevel_atom()
	return src

/area/get_toplevel_atom()
	return src

/proc/trange(rad = 0, turf/centre) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)
