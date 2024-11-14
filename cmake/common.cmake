cmake_minimum_required(VERSION 3.27.1)

# when cmake functions are overridden the original version of the function can
# be called by prepending the function call with an underscore
# override the cmake project() function to a noop

# Trick to temporarily redefine project(). When functions are overridden in 
# CMake, the originals can still be accessed using an underscore prefixed 
# function of the same name. The following lines make sure that __project  calls
# the original project(). See https://cmake.org/pipermail/cmake/2015-October/061751.html.

function(project)
endfunction()

function(_project)
endfunction()

macro(project project_name)
# call the original cmake project() function
__project(${project_name} C ASM CXX)

set(CMAKE_EXECUTABLE_SUFFIX .elf)

if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
    set(PYTHON_EXECUTABLE "python3")
elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
    set(PYTHON_EXECUTABLE "python")
else()
    set(PYTHON_EXECUTABLE "python3")
endif()

if(NOT DEFINED CMAKE_PARALLEL_BUILD_LEVEL)
    set(CMAKE_PARALLEL_BUILD_LEVEL 1)
endif()

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_executable(${PROJECT_NAME})

if(${REGEN})
    execute_process(
        COMMAND ${PYTHON_EXECUTABLE}
        ${WORKSPACE_BASE}/config.py
        -w ${WORKSPACE_BASE}
        -c ${CMAKE_CURRENT_SOURCE_DIR}/proj.conf
        -d ${CMAKE_BINARY_DIR}
        -m
        -a ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE ret_config
    )

    if(${ret_config} EQUAL "1")
        message(FATAL_ERROR ret_config)
        return()
    endif()
endif()

execute_process(
    COMMAND ${PYTHON_EXECUTABLE}
    ${SDK_BASE}/scripts/kconfig/read_config.py
    -d ${CMAKE_BINARY_DIR}
    OUTPUT_VARIABLE CONFIG   
)

# convert stdout string from the script into a list 
foreach(item ${CONFIG})
    # load kconfig symbols as cmake variables
    cmake_language(EVAL CODE "set (${item})")
endforeach()

include(${WORKSPACE_BASE}/platform/CMakeLists.txt)
include(${WORKSPACE_BASE}/CMakeLists.txt)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${DRIVER_INC}
    ${CMAKE_BINARY_DIR}
    ${SDK_BASE}/modules/CMSIS_5/CMSIS/Core/Include
    ${SDK_BASE}/modules/cmsis_device_f7/Include
    ${SDK_BASE}/modules/gcc-arm-none-eabi/gcc-arm-none-eabi-10.3-2021.10/arm-none-eabi/include
    ${WORKSPACE_BASE}/platform/include
)

set(CMSIS_SYSTEM ${SDK_BASE}/modules/cmsis_device_f7/Source/Templates/system_stm32f7xx.c)
set(CMSIS_STARTUP ${SDK_BASE}/modules/cmsis_device_f7/Source/Templates/gcc/startup_stm32f722xx.s)

set(SOURCES
    ${CMSIS_SYSTEM}
    ${CMSIS_STARTUP}
    ${DRIVER_SRC}
)

target_sources(${PROJECT_NAME} PUBLIC ${SOURCES})

target_link_options(${PROJECT_NAME} PRIVATE
    -T${WORKSPACE_BASE}/platform/STM32F722ZETx_FLASH.ld
    --specs=nosys.specs -DSTM32F722xx -g3
    -Wl,-Map=test.map-Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group
)

target_link_libraries(${PROJECT_NAME} m)

add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ihex ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.elf ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.hex
        COMMAND ${CMAKE_OBJDUMP} --source --all-headers --demangle --line-numbers --wide ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.elf > ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.lst
        COMMAND ${CMAKE_SIZE} --format=sysv --totals --radix=16 ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.elf
)

endmacro() # project