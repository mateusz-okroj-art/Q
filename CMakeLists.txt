cmake_minimum_required(VERSION 3.16)

project(Root)

	if(DEFINED WIN32 AND (NOT DEFINED QT_PATH OR NOT EXISTS ${QT_PATH}))
		set(QT_PATH "C:/Qt/")
	endif()

	if(EXISTS ${QT_PATH})
		message(FATAL_ERROR "Qt 6 not found.")
	endif()

	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	set(CMAKE_AUTOMOC ON)
	set(CMAKE_AUTORCC ON)
	set(CMAKE_AUTOUIC ON)

	list(APPEND CMAKE_PREFIX_PATH ${QT_PATH})

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

	find_package(GTest CONFIG REQUIRED)
	find_package(rtmidi CONFIG REQUIRED)
	find_package(Qt6 REQUIRED COMPONENTS Core)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)