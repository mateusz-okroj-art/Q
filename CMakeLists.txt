cmake_minimum_required(VERSION 3.20)

project(Root)

include(packages.cake)
include(.vcpkg/scripts/buildsystems/vcpkg.cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Fix GTest
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

add_subdirectory(libs)
add_subdirectory(app)