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

		find_program(vcpkg_app NAMES vcpkg HINTS ${vcpkg_dir})

		execute_process(
			COMMAND ${vcpkg_app} update
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while updating VCPKG.")
		endif()
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

	find_program(vcpkg_app NAMES vcpkg HINTS ${vcpkg_dir})

	execute_process(
		COMMAND ${vcpkg_app} update
		RESULT_VARIABLE result_process
	)

	if(NOT ${result_process} EQUAL "0")
		message(FATAL_ERROR "Error while updating VCPKG.")
	endif()

	foreach(package_name ${${vcpkg_libraries}})
		message(STATUS "vcpkg: Installing '${package_name}'...")

		execute_process(
			COMMAND ${vcpkg_app} install ${package_name}
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while installing vcpkg - ${package_name}.")
		endif()
	endforeach()
endfunction()

function(ConfigureToolchainPath)
	if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(
			CMAKE_TOOLCHAIN_FILE
			"${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake"
			PARENT_SCOPE)
	elseif(EXISTS "/usr/local/share/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(
			CMAKE_TOOLCHAIN_FILE
			"/usr/local/share/vcpkg/scripts/buildsystems/vcpkg.cmake"
			PARENT_SCOPE)
	elseif(EXISTS "C:/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(
			CMAKE_TOOLCHAIN_FILE
			"C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
			PARENT_SCOPE)
	else()
		message(FATAL_ERROR "Not found vcpkg.cmake.")
	endif()

	message("Toolchain path was set to: ${CMAKE_TOOLCHAIN_FILE}.")
endfunction()