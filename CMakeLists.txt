cmake_minimum_required(VERSION 3.16)

project(Root)

if(DEFINED MODE AND MODE STREQUAL "install")

	include(packages.cmake)
	include(cmake/BuildPackage.cmake)

	BUILD_VCPKG_PACKAGE(3rd_packages)

else()

	include(cmake/GetDependenciesVersion.cmake)
	GETDEPENDENCIESVERSION(DependenciesVersion)

	if(DEFINED DependenciesVersion AND NOT ${DependenciesVersion} STREQUAL "null")

		message("Required dependencies version is: ${DependenciesVersion}")
		message("Current dependencies version is: ${CurrentDependenciesVersion}")

		set(VCPKG_CMAKE .vcpkg/scripts/buildsystems/vcpkg.cmake)

		if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${VCPKG_CMAKE} OR NOT DEFINED CurrentDependenciesVersion OR NOT ${DependenciesVersion} STREQUAL ${CurrentDependenciesVersion})

			include(cmake/InstallPackage.cmake)
			INSTALL_VCPKG_PACKAGE(${DependenciesVersion})

			set(CurrentDependenciesVersion ${DependenciesVersion} CACHE INTERNAL "Current dependencies version installed on cache." FORCE)

		endif()
	
		include(${VCPKG_CMAKE})

	endif()

	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)

	# Fix GTest
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

	add_subdirectory(libs)
	add_subdirectory(app)

endif()