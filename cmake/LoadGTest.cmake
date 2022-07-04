include(ExternalProject)

message("Installing Google Test...")

ExternalProject_Add(GOOGLETEST
	GIT_REPOSITORY https://github.com/google/googletest
	GIT_BRANCH master  # it's much better to use a specific Git revision or Git tag for reproducability
	CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
	CMAKE_CACHE_ARGS -Dmyvar:STRING=${mylist}   # need variable type e.g. STRING for this
	CONFIGURE_HANDLED_BY_BUILD ON
	BUILD_BYPRODUCTS ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}
)

add_library(gtest STATIC IMPORTED GLOBAL)
set_target_properties(gtest PROPERTIES
IMPORTED_LOCATION ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}
INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_INSTALL_PREFIX}/include)