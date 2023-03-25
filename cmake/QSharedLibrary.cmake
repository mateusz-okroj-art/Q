include(GNUInstallDirs)
include(GenerateExportHeader)

function(Q_SharedLibrary ENABLE_QT)

	add_library(${PROJECT_NAME} SHARED ${SOURCES})

	if(ENABLE_QT EQUAL true)
		set(CMAKE_AUTOMOC ON)
		set(CMAKE_AUTORCC ON)
		set(CMAKE_AUTOUIC ON)
	endif()

	set(_public_libs "")

	if(DEFINED PUBLIC_LIBS)
		foreach(lib ${PUBLIC_LIBS})
			list(APPEND _public_libs PUBLIC ${lib})
		endforeach()
	endif()

	set(_private_libs "")

	if(DEFINED PRIVATE_LIBS)
		foreach(lib ${PRIVATE_LIBS})
			list(APPEND _private_libs PRIVATE ${lib})
		endforeach()
	endif()

	target_link_libraries(${PROJECT_NAME} ${_public_libs} ${_private_libs})

	set(_public_headers "")

	if(DEFINED PUBLIC_HEADERS)
		foreach(file ${PUBLIC_HEADERS})
			list(APPEND _public_headers PUBLIC_HEADER file)
		endforeach()
	endif()

	target_include_directories(
		${PROJECT_NAME}
		PUBLIC ${CMAKE_BINARY_DIR}/exports
		PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
		${_public_libs}
		${_private_libs}
		${_public_headers}
	)

	string(REGEX REPLACE "[^A-z0-9_]" "_" _export_header_name ${PROJECT_NAME})

	generate_export_header(${PROJECT_NAME}
		EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/exports/${_export_header_name}.h
	)

	include(GNUInstallDirs)

	install(
		TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin
		ARCHIVE DESTINATION bin
		LIBRARY DESTINATION lib
		PUBLIC_HEADER DESTINATION include
	)

endfunction()