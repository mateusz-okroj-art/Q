set(VCPKG_PATH "${CMAKE_BINARY_DIR}/vcpkg")
if(NOT EXISTS "${VCPKG_PATH}/bootstrap-vcpkg.sh"
 OR NOT EXISTS "${VCPKG_PATH}/bootstrap-vcpkg.bat"
 OR NOT EXISTS ${VCPKG_PATH}/scripts/buildsystems/vcpkg.cmake)
	message("Downloading VCPKG...")
	execute_process(COMMAND git clone "https://github.com/Microsoft/vcpkg.git" ${VCPKG_PATH})
else()
	message("Updating VCPKG...")
	execute_process(
		WORKING_DIRECTORY ${VCPKG_PATH}
		COMMAND git pull
	)
endif()

message("Configuring VCPKG...")

if(WIN32)
	execute_process(COMMAND "${VCPKG_PATH}/bootstrap-vcpkg.bat")
else()
	execute_process(COMMAND "${VCPKG_PATH}/bootstrap-vcpkg.sh")
endif()

if(WIN32)
	set(VCPKG_APP "${VCPKG_PATH}/vcpkg.exe")
else()
	set(VCPKG_APP "${VCPKG_PATH}/vcpkg")
endif()

message("vcpkg: Updating packages...")

execute_process(COMMAND ${VCPKG_APP} update)

foreach(pkg_name ${VCPKG_Install_List})
	message("vcpkg: Installing ${pkg_name}")
	execute_process(COMMAND ${VCPKG_APP} install ${pkg_name})
endforeach()

include(${VCPKG_PATH}/scripts/buildsystems/vcpkg.cmake)