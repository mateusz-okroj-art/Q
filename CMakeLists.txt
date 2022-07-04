cmake_minimum_required(VERSION 3.20)

project(Root)

set(VCPKG_Install_List
	
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

include(cmake/ConfigureVCPKG.cmake)
include(cmake/LoadGTest.cmake)

find_package(Qt6 REQUIRED COMPONENTS Core)

add_subdirectory(libs)
add_subdirectory(app)