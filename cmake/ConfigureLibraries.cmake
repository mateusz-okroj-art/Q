function(ConfigureLibraries src_path triplet)
	add_library(asiosdk INTERFACE)
	target_include_directories(asiosdk INTERFACE "/out/build/vcpkg/packages/asiosdk_${triplet}/include/")
	
	set(rtmidi_DIR "${src_path}/out/build/vcpkg/packages/rtmidi_/share/rtmidi/")
	set(bson-1.0_DIR "${src_path}/out/build/vcpkg/packages/libbson_${triplet}/share/bson-1.0/")
	list(APPEND CMAKE_PREFIX_PATH "${src_path}/out/build/vcpkg/packages/")

	find_package(GTest CONFIG REQUIRED)
	find_package(rtmidi CONFIG REQUIRED)
	find_package(rxcpp CONFIG REQUIRED)
	find_package(bson-1.0 CONFIG REQUIRED)

	add_library(rxqt INTERFACE)
	target_include_directories(rxqt INTERFACE "${src_path}/out/build/vcpkg/packages/asiosdk_${triplet}/include/")
	
	find_package(Qt6 REQUIRED COMPONENTS Core)
endfunction()