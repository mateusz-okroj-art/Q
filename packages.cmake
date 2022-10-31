set(3rd_packages
	rxcpp
	gtest
	rtmidi
)

if(DEFINED WIN32)
	list(APPEND 3rd_packages
		asiosdk
	)
endif()