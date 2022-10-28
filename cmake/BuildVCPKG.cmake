function(Build_VCPKG vcpkg_libraries)
	list(LENGTH vcpkg_libraries list_length)

	if(list_length EQUAL 0)
		message(FATAL_ERROR "Variable must be a non-empty list.")
	endif()

	set(vcpkg_dir '${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg')

	if(NOT IS_DIRECTORY ${vcpkg_dir})
		if(IS_DIRECTORY '/usr/local/share/vcpkg')
			set(vcpkg_dir '/usr/local/share/vcpkg')
		endif()
	endif()

	if(IS_DIRECTORY ${vcpkg_dir})
		execute_process(
			WORKING_DIRECTORY ${vcpkg_dir}
			COMMAND git pull --progress
		)

		find_program(vcpkg_app NAMES vcpkg HINTS ${vcpkg_dir})

		execute_process(
			COMMAND ${vcpkg_app} update
			RESULT_VARIABLE result_process
		)
	else()
		message(STATUS "Downloading VCPKG...")

		execute_process(
			WORKING_DIRECTORY '${CMAKE_CURRENT_LIST_DIR}/out/build'
			COMMAND git clone --progress "https://github.com/microsoft/vcpkg.git"
		)

		if(WIN32)
			if(${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
				set(VCPKG_START ${vcpkg_dir}/bootstrap-vcpkg.bat)
			else()
				message(FATAL_ERROR "Compiler must be a MSVC on Win32 platform.\nCurrently is '${CMAKE_CXX_COMPILER_ID}'.")
			endif()
		else()
			set(VCPKG_START ${vcpkg_dir}/bootstrap-vcpkg.sh)
		endif()

		message(STATUS "Installing VCPKG...")

		execute_process(
			COMMAND ${VCPKG_START}
			RESULT_VARIABLE result_process
		)
	endif()

	find_program(vcpkg_app NAMES vcpkg HINTS ${vcpkg_dir})

	foreach(package_name ${${vcpkg_libraries}})
		message(STATUS "vcpkg: Installing ${package_name}...")
		execute_process(
			COMMAND ${vcpkg_app} install ${package_name}
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while installing vcpkg - ${package_name}.")
		endif()
	endforeach()
endfunction()