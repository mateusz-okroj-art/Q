function(Install_VCPKG_Package dep_version_id)

	message(FATAL_ERROR "Not implemented yet.") ######################

	string(REGEX MATCH "\\d+" version_id ${dep_version_id})

	string(LENGTH version_id version_length)

	if(${version_length} LESS 20)
		message(FATAL_ERROR "Version ID is invalid.")
	endif()



endfunction()