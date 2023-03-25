cmake_minimum_required(VERSION 3.16)

#project(Root)

#	if(DEFINED QT_PATH AND EXISTS ${QT_PATH})
#		list(APPEND CMAKE_PREFIX_PATH ${QT_PATH})
#	endif()

#	set(CMAKE_CXX_STANDARD_REQUIRED ON)

#	include(cmake/ConfigureVCPKG.cmake)
#	include(cmake/QSharedLibrary.cmake)
#	include(packages.cmake)

#	BUILD_VCPKG(3rd_packages)
	
#	if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")
#		set(
#			CMAKE_TOOLCHAIN_FILE
#			"${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")

#		message("Toolchain path was set to: ${CMAKE_TOOLCHAIN_FILE}.")
#	else()
#		message(FATAL_ERROR "Not found vcpkg.cmake.")
#	endif()

#	set(CMAKE_CXX_STANDARD 20)
#	set(CMAKE_CXX_STANDARD_REQUIRED ON)
	
#	include(cmake/ConfigureLibraries.cmake)
#	CONFIGURELIBRARIES(${CMAKE_CURRENT_LIST_DIR} ${triplet})

	# Fix GTest
#	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

#	add_subdirectory(libs)
#	add_subdirectory(app)

#TODO: Debugging new VCPKG system

include(cmake/ConfigureVCPKG.cmake)

READVCPKGCONFIGURATIONFILE(json_config_str)

print(${json_config_str})