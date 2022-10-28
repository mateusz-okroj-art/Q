cmake_minimum_required(VERSION 3.16)

project(Root)

	option(QT_PATH "Path to Qt6 cmake scripts.")

	if(DEFINED WIN32 AND (NOT DEFINED QT_PATH OR NOT IS_DIRECTORY ${QT_PATH}))
		set(QT_PATH "C:/Qt/")
	endif()

	include(cmake/BuildVCPKG.cmake)
	include(packages.cmake)
	BUILD_VCPKG(3rd_packages)

	if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/out/build/vcpkg/scripts/buildsystems/vcpkg.cmake")
	elseif(EXISTS "/usr/local/share/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(CMAKE_TOOLCHAIN_FILE "/usr/local/share/vcpkg/scripts/buildsystems/vcpkg.cmake")
	elseif(EXISTS "C:/vcpkg/scripts/buildsystems/vcpkg.cmake")
		set(CMAKE_TOOLCHAIN_FILE "C:/vcpkg/scripts/buildsystems/vcpkg.cmake")
	else()
		message(FATAL_ERROR "Not found vcpkg.cmake.")
	endif()

	message("Toolchain path set to: ${CMAKE_TOOLCHAIN_FILE}.")

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	list(APPEND CMAKE_PREFIX_PATH ${QT_PATH})

	find_package(Qt6 REQUIRED COMPONENTS Core)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)