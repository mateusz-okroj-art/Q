set(3rd_packages
	rxcpp
	rxqt
	gtest
	rtmidi
	libbson
)

if(DEFINED WIN32)
	list(APPEND 3rd_packages
		asiosdk
	)
endif()