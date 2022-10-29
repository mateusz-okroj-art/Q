cmake_minimum_required(VERSION 3.16)

project(Root)

	if(DEFINED WIN32 AND (NOT DEFINED QT_PATH OR NOT EXISTS ${QT_PATH}))
		set(QT_PATH "C:/Qt/")
	endif()

	if(NOT EXISTS ${QT_PATH})
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
	CONFIGURETOOLCHAINPATH()

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	find_package(Qt6 REQUIRED COMPONENTS Core)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)