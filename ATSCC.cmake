

MACRO (ATS_TYPE_CHECK SRC)
	EXECUTE_PROCESS (
		COMMAND atscc -tc ${SRC}
		RESULT_VARIABLE _ATS_TC_RESULT
		OUTPUT_VARIABLE _ATS_TC_OUTPUT
		ERROR_VARIABLE _ATS_TC_ERROR
		OUTPUT_STRIP_TRAILING_WHITESPACE
		ERROR_STRIP_TRAILING_WHITESPACE)
	MESSAGE (STATUS ${_ATS_TC_OUTPUT})

	UNSET (_ATS_TC_RESULT)
	UNSET (_ATS_TC_OUTPUT)
	UNSET (_ATS_TC_ERROR)
ENDMACRO ()

MACRO (ATS_COMPILE OUTPUT SRC)
	
	IF (NOT "${OUTPUT}" MATCHES "^${OUTPUT}$")
		MESSAGE (STATUS "Parameter should be a variable instead of the value of variable!")
		MESSAGE (FATAL_ERROR "Example: ATS_COMPILE (C_OUTPUT, ${SOURCE_FILES})")
	ENDIF ()

	SET (_ATS_FILES ${SRC} ${ARGN})
	SET (_C_OUTPUT)

	FOREACH (_ATS_FILE ${_ATS_FILES})
		#FOR STATIC FILES
		IF (${_ATS_FILE} MATCHES "\\.sats$")
			STRING(REPLACE ".sats" "_sats.c" _SATS_C ${_ATS_FILE})
			ADD_CUSTOM_COMMAND (
			    OUTPUT ${_SATS_C} 
			    COMMAND atsopt --output ${_SATS_C} --static ${_ATS_FILE}
			    DEPENDS ${_ATS_FILE}
		  	)
		  	LIST (APPEND _C_OUTPUT ${_SATS_C})
		#FOR DYNAMIC FILES
		ELSEIF (${_ATS_FILE} MATCHES "\\.dats$")
			STRING(REPLACE ".dats" "_dats.c" _DATS_C ${_ATS_FILE})
			ADD_CUSTOM_COMMAND (
			    OUTPUT ${_DATS_C} 
			    COMMAND atsopt --output ${_DATS_C} --dynamic ${_ATS_FILE}
			    DEPENDS ${_ATS_FILE}
		  	)
		  	LIST (APPEND _C_OUTPUT ${_DATS_C})
		ENDIF ()
	ENDFOREACH()

	SET (${OUTPUT} ${_C_OUTPUT})

	UNSET (_ATS_FILES)
	UNSET (_ATS_FILE)
	UNSET (_C_OUTPUT)
	UNSET (_SATS_C)
	UNSET (_DATS_C)

ENDMACRO ()
