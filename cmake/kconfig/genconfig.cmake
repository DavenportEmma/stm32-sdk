function(genconfig)
	execute_process(
		COMMAND ${PYTHON_EXECUTABLE} modules/kconfiglib/genconfig.py
		--header-path ${CMAKE_BINARY_DIR}/autoconf.h
		--config-out ${CMAKE_BINARY_DIR}/.config
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		COMMAND_ERROR_IS_FATAL ANY
	)
endfunction()