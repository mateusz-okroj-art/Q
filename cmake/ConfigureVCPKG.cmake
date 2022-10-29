function(Build_VCPKG vcpkg_libraries)
	list(LENGTH vcpkg_libraries list_length)

	if(list_length EQUAL 0)
		message(FATAL_ERROR "Variable must be a non-empty list.")
	endif()

	find_program(Git NAMES git)

	message("Detected current list dir: '${CMAKE_CURRENT_LIST_DIR}'.")

	set(vcpkg_dir "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg")

	if(EXISTS ${vcpkg_dir})
		message(STATUS "Updating VCPKG...")

		execute_process(
			WORKING_DIRECTORY ${vcpkg_dir}
			COMMAND ${Git} pull --progress
		)
	else()
		message(STATUS "Downloading VCPKG...")

		execute_process(
			WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out/build"
			COMMAND ${Git} clone --progress "https://github.com/microsoft/vcpkg.git"
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while downloading VCPKG from Github.")
		endif()

		if(DEFINED WIN32)
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

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while executing VCPKG install script.")
		endif()
	endif()

	execute_process(
		WORKING_DIRECTORY ${vcpkg_dir}
		COMMAND ./vcpkg update
	)

	foreach(package_name ${${vcpkg_libraries}})
		message(STATUS "vcpkg: Installing '${package_name}'...")

		execute_process(
			WORKING_DIRECTORY ${vcpkg_dir}
			COMMAND ./vcpkg install "${package_name}"
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while installing vcpkg - ${package_name}.")
		endif()
	endforeach()
endfunction()