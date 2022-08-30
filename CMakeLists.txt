cmake_minimum_required(VERSION 3.20)

project(Root)

if(DEFINED MODE AND MODE STREQUAL "install")

	include(packages.cake)
	include(cmake/BuildPackage.cmake)

	BUILD_VCPKG_PACKAGE(${3rd_packages})

else()

	set(VCPKG_CMAKE .vcpkg/scripts/buildsystems/vcpkg.cmake)

	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${VCPKG_CMAKE})

		include(cmake/GetDependenciesVersion.cmake)
		include(cmake/InstallPackage.cmake)
		
	endif()
	
	include(${VCPKG_CMAKE})

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)

endif()