project(lib)

set(SOURCES main.cpp)

set(PUBLIC_HEADERS h.h)

set(PRIVATE_LIBS mongo::bson_shared)

Q_SHAREDLIBRARY()