cmake_minimum_required(VERSION 3.16)

project(Root)

	include(cmake/BuildVCPKG.cmake)
	include(packages.cmake)
	BUILD_VCPKG(3rd_packages)

	include("out/build/.vcpkg/scripts/buildsystems/vcpkg.cmake")

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	list(APPEND CMAKE_PREFIX_PATH "C:/Qt/msvc_x64")

	find_package(Qt6 REQUIRED COMPONENTS Core)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)