# This file can be dropped into a project to help locate the Pimoroni Pico libraries
# It will also set up the required include and module search paths.

if (DEFINED ENV{PIMORONI_PICO_PATH} AND (NOT PIMORONI_PICO_PATH))
    set(PIMORONI_PICO_PATH $ENV{PIMORONI_PICO_PATH})
    message("Using PIMORONI_PICO_PATH from environment ('${PIMORONI_PICO_PATH}')")
endif ()

if (DEFINED ENV{PIMORONI_PICO_FETCH_FROM_GIT} AND (NOT PIMORONI_PICO_FETCH_FROM_GIT))
    set(PIMORONI_PICO_FETCH_FROM_GIT $ENV{PIMORONI_PICO_FETCH_FROM_GIT})
    message("Using PIMORONI_PICO_FETCH_FROM_GIT from environment ('${PIMORONI_PICO_FETCH_FROM_GIT}')")
endif ()

if (DEFINED ENV{PIMORONI_PICO_FETCH_FROM_GIT_PATH} AND (NOT PIMORONI_PICO_FETCH_FROM_GIT_PATH))
    set(PIMORONI_PICO_FETCH_FROM_GIT_PATH $ENV{PIMORONI_PICO_FETCH_FROM_GIT_PATH})
    message("Using PIMORONI_PICO_FETCH_FROM_GIT_PATH from environment ('${PIMORONI_PICO_FETCH_FROM_GIT_PATH}')")
endif ()

set(PIMORONI_PICO_PATH "${PIMORONI_PICO_PATH}" CACHE PATH "Path to the Raspberry Pi Pico SDK")
set(PIMORONI_PICO_FETCH_FROM_GIT "${PIMORONI_PICO_FETCH_FROM_GIT}" CACHE BOOL "Set to ON to fetch copy of Pico SDK from git if not otherwise locatable")
set(PIMORONI_PICO_FETCH_FROM_GIT_PATH "${PIMORONI_PICO_FETCH_FROM_GIT_PATH}" CACHE FILEPATH "location to download Pico SDK")

if (NOT PIMORONI_PICO_PATH)
    if (PIMORONI_PICO_FETCH_FROM_GIT)
        include(FetchContent)
        set(FETCHCONTENT_BASE_DIR_SAVE ${FETCHCONTENT_BASE_DIR})
        if (PIMORONI_PICO_FETCH_FROM_GIT_PATH)
            get_filename_component(FETCHCONTENT_BASE_DIR "${PIMORONI_PICO_FETCH_FROM_GIT_PATH}" REALPATH BASE_DIR "${CMAKE_SOURCE_DIR}")
        endif ()
        # GIT_SUBMODULES_RECURSE was added in 3.17
        if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.17.0")
            FetchContent_Declare(
                    pimoroni_pico
                    GIT_REPOSITORY https://github.com/pimoroni/pimoroni-pico
                    GIT_TAG main
                    GIT_SUBMODULES_RECURSE FALSE
            )
        else ()
            FetchContent_Declare(
                pimoroni_pico
                    GIT_REPOSITORY https://github.com/pimoroni/pimoroni-pico
                    GIT_TAG main
            )
        endif ()

        if (NOT PIMORONI_PICO)
            message("Downloading Pimoroni Pico libraries")
            FetchContent_Populate(PIMORONI_PICO)
            set(PIMORONI_PICO_PATH ${pimoroni_pico_SOURCE_DIR})
        endif ()
        set(FETCHCONTENT_BASE_DIR ${FETCHCONTENT_BASE_DIR_SAVE})
    else ()
        message(FATAL_ERROR
                "Pimoroni Pico SDK location was not specified. Please set PIMORONI_PICO_PATH or set PIMORONI_PICO_FETCH_FROM_GIT to on to fetch from git."
                )
    endif ()
endif ()

get_filename_component(PIMORONI_PICO_PATH "${PIMORONI_PICO_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${PIMORONI_PICO_PATH})
    message(FATAL_ERROR "Directory '${PIMORONI_PICO_PATH}' not found")
endif ()

set(PIMORONI_PICO_INIT_CMAKE_FILE ${PIMORONI_PICO_PATH}/pimoroni_pico_import.cmake)
if (NOT EXISTS ${PIMORONI_PICO_INIT_CMAKE_FILE})
    message(FATAL_ERROR "Directory '${PIMORONI_PICO_PATH}' does not appear to contain the Pimoroni Pico libraries")
endif ()

set(PIMORONI_PICO_PATH ${PIMORONI_PICO_PATH} CACHE PATH "Path to the Pimoroni Pico libraries" FORCE)

include(${PIMORONI_PICO_INIT_CMAKE_FILE})
