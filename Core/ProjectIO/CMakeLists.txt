project(Q.Core.ProjectIO)

set(SOURCES
	serializer.cpp
)

add_library(
	${PROJECT_NAME} SHARED ${SOURCES})

	target_include_directories(
		${PROJECT_NAME}
		PUBLIC ${CMAKE_BINARY_DIR}/exports
		PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
		PUBLIC_HEADER ProjectIO_Serializer.h
	)

	generate_export_header(${PROJECT_NAME}
		EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/exports/QCoreProjectIOExport.h
	)

	include(GNUInstallDirs)

	install(
		TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin
		ARCHIVE DESTINATION bin
		LIBRARY DESTINATION lib
		PUBLIC_HEADER DESTINATION include
	)