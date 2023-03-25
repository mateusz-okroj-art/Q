project(Q.Core.Filesystem)

set(SOURCES
	file.cpp
)

set(PUBLIC_HEADERS
	Filesystem_File.h
)

set(PUBLIC_LIBS
	Qt6::Core
)

Q_SHAREDLIBRARY(True)