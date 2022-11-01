cmake_minimum_required(VERSION 3.16)

project(Root)

	if(DEFINED QT_PATH AND EXISTS ${QT_PATH})
		list(APPEND CMAKE_PREFIX_PATH ${QT_PATH})
	endif()

	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	set(CMAKE_AUTOMOC ON)
	set(CMAKE_AUTORCC ON)
	set(CMAKE_AUTOUIC ON)

	include(cmake/ConfigureVCPKG.cmake)
	include(packages.cmake)

	BUILD_VCPKG(3rd_packages)
	
	if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(
			CMAKE_TOOLCHAIN_FILE
			"${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")

		message("Toolchain path was set to: ${CMAKE_TOOLCHAIN_FILE}.")
	else()
		message(FATAL_ERROR "Not found vcpkg.cmake.")
	endif()

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)
	
	add_library(asiosdk INTERFACE)
	target_include_directories(asiosdk INTERFACE "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/packages/asiosdk_${triplet}/include/")
	
	set(rtmidi_DIR "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/packages/rtmidi_${triplet}/share/rtmidi/")
	list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/packages/")

	find_package(GTest CONFIG REQUIRED)
	find_package(rtmidi CONFIG REQUIRED)
	find_package(rxcpp CONFIG REQUIRED)

	add_library(rxqt INTERFACE)
	target_include_directories(rxqt INTERFACE "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/packages/asiosdk_${triplet}/include/")
	
	find_package(Qt6 REQUIRED COMPONENTS Core)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)