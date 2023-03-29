function(ReadVCPKGConfigurationFile variable_name)
	file(READ ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/packages.json file_str)

	if(NOT DEFINED file_str OR ${file_str} EQUAL "")
		message(FATAL_ERROR "Packages list not found.")
	endif()

	set(${variable_name} ${file_str} PARENT_SCOPE)
endfunction()

function(ConfigurePlatform json_file platform_name)	
	if(${platform_name} STREQUAL "Windows")
		# Currently no required
	elseif(${platform_name} STREQUAL "Linux")
		message(STATUS "Updating APT...")

		execute_process(
			COMMAND apt update
		)

		message(STATUS "Upgrading APT packages...")

		execute_process(
			COMMAND apt upgrade
		)

		execute_process(
			COMMAND apt list --installed
			OUTPUT_VARIABLE out_var
		)

		#message(${out_var})

		string(JSON arr_len LENGTH ${json_file})

		foreach(i RANGE 0 ${arr_len})
			string(JSON platform_description GET ${json_file} ${i})
			string(JSON name GET ${platform_description} platform)

			if(${name} STREQUAL ${platform_name})
				string(JSON apt_required_packages GET ${json_file} apt-packages)

				foreach(package_name ${apt_required_packages})

				endforeach()
			endif()
		endforeach()
	elseif(${platform_name} STREQUAL "Darwin")

	else()
		message(FATAL_ERROR "Configure VCPKG: Unsupported platform.")
	endif()
endfunction()

function(GetVCPKGPath variable_name)
	find_program(VCPKG NAMES vcpkg)

	if(NOT EXISTS ${VCPKG})
		message(FATAL_ERROR "VCPKG not found. Set valid path to PATH system environment variable.")
	endif()

	set(${variable_name} ${VCPKG} PARENT_SCOPE)
endfunction()

function(DetectPlatformAndTripletName platform_var triplet_var)
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

		#TODO implement support for Apple M1, M2 - arm64-osx
	else()
		message(FATAL_ERROR "Unsupported OS.")
	endif()

	set(${platform_var} ${CMAKE_SYSTEM_NAME} PARENT_SCOPE)
	set(${triplet_var} ${triplet} PARENT_SCOPE)
endfunction()

function(ConfigureVCPKG)
	GetVCPKGPath(vcpkg_app)
	get_filename_component(vcpkg_dir ${vcpkg_app} DIRECTORY)

	message(STATUS "Found VCPKG: ${vcpkg_app}")

	find_program(git NAMES git)

	message(STATUS "Updating VCPKG...")

	execute_process(
		WORKING_DIRECTORY ${vcpkg_dir}
		COMMAND git pull -r
	)

	execute_process(COMMAND ${vcpkg_app} update)

	message(STATUS "Reading packages.json...")
	ReadVCPKGConfigurationFile(packages_json)

	DetectPlatformAndTripletName(platform_name triplet)
	message("Detected platform: ${platform_name} - ${triplet}")

	message(STATUS "Configuring platform...")
	ConfigurePlatform(${packages_json} ${platform_name})


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