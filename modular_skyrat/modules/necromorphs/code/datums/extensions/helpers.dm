/*
	Its bad that wallrun and wallmount aren't the same system, that needs to be fixed. For now, this dirty abstraction layer will do

	There will be colon access, they share proc and variable names
*/
/atom/proc/handle_existing_mounts(var/override = TRUE)
	for(var/datum/component/wallrun/wallrun as anything in GetComponents(/datum/component/wallrun))
		if(wallrun.mountpoint) //If set, this means it's mounted
			if(!override)
				return FALSE	//Without override, we fail on any existing mounts

			//Unmount it
			wallrun.unmount()
	for(var/datum/component/mount/mount as anything in GetComponents(/datum/component/mount))
		if (mount.mountpoint) //If set, this means it's mounted
			if (!override)
				return FALSE	//Without override, we fail on any existing mounts

			//Unmount it
			mount.dismount()
	return TRUE
