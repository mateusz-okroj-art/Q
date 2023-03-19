project(Q.Core.BSON)

set(SOURCES
	bson.cpp
)

add_library(
	${PROJECT_NAME} SHARED ${SOURCES})

	target_link_libraries(${PROJECT_NAME} PUBLIC mongo::bson_shared)

	target_include_directories(
		${PROJECT_NAME}
		PUBLIC ${CMAKE_BINARY_DIR}/exports
		PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
		PUBLIC_HEADER Core_BSONDocument.h
	)

	generate_export_header(${PROJECT_NAME}
		EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/exports/QCoreBSONExport.h
	)

	include(GNUInstallDirs)

	install(
		TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin
		ARCHIVE DESTINATION bin
		LIBRARY DESTINATION lib
		PUBLIC_HEADER DESTINATION include
	)