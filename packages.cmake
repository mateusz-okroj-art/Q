set(3rd_packages
	rxcpp
	rxqt
	gtest
	rtmidi
	mongo-c-driver
)

if(DEFINED WIN32)
	list(APPEND 3rd_packages
		asiosdk
	)
endif()