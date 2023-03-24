function(ConfigurePlatform platform_name)
	file()
	
	if(${platform_id} equal "x64-windows")
		
	elseif(${platform_id} equal "x64-linux")

	elseif(${platform_id} equal "x64-macosx")

	else()
		message(FATAL_ERROR "Configure VCPKG: Unsupported platform.")
	endif()
function(ConfigureVCPKG)
	
endfunction()

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

	if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
		if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64" OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x64")
			set(triplet "x64-windows")
		elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "i686")
			set(triplet "x86-windows")
		elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
			set(triplet "arm64-windows")
		else()
			message(FATAL_ERROR "Unsupported architecture '${CMAKE_HOST_SYSTEM_PROCESSOR}'.")
		endif()
	elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
		if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64" OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x64")
			set(triplet "x64-linux")
		elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "i686")
			set(triplet "x86-linux")
		elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
			set(triplet "arm64-linux")
		else()
			message(FATAL_ERROR "Unsupported architecture '${CMAKE_HOST_SYSTEM_PROCESSOR}'.")
		endif()
	elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
		set(triplet "x64-osx")
	else()
		message(FATAL_ERROR "Unsupported OS.")
	endif()

	foreach(package_name ${${vcpkg_libraries}})
		message(STATUS "vcpkg: Installing '${package_name}'...")

		execute_process(
			WORKING_DIRECTORY ${vcpkg_dir}
			COMMAND ./vcpkg install "${package_name}" --triplet=${triplet}
			RESULT_VARIABLE result_process
		)

		if(NOT ${result_process} EQUAL "0")
			message(FATAL_ERROR "Error while installing vcpkg - ${package_name}.")
		endif()
	endforeach()

	set(triplet ${triplet} CACHE STRING "")
endfunction()