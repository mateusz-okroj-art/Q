function(GetDependenciesVersion variable_name)

	file(READ ${CMAKE_SOURCE_DIR}/Versions.json VERSIONS_JSON)

	string(JSON dep_version_id ERROR_VARIABLE error_var GET ${VERSIONS_JSON} Dependencies)

	if(DEFINED error_var AND NOT ${error_var} STREQUAL "NOTFOUND")
		message(FATAL_ERROR ${error_var})
	endif()

	set(${variable_name} ${dep_version_id} PARENT_SCOPE)
endfunction()