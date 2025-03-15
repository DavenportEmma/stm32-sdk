set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
	set(CMAKE_MAKE_PROGRAM ${SDK_BASE}/modules/ninja/ninja CACHE FILEPATH "")
elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
	set(CMAKE_MAKE_PROGRAM ${SDK_BASE}/modules/ninja/ninja.exe CACHE FILEPATH "")
endif()

set(CMAKE_GENERATOR "Ninja" CACHE INTERNAL "" FORCE)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)
SET(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_SYSTEM_PROCESSOR arm)
# variable that is used for the toolchain
set(gcc_arm_toolchain_base ${SDK_BASE}/modules/gcc-arm-none-eabi/gcc-arm-none-eabi-10.3-2021.10)

# here is the target environment located
set(CMAKE_FIND_ROOT_PATH ${gcc_arm_toolchain_base})

set(gcc_arm_toolchain_bin_path ${gcc_arm_toolchain_base}/bin)
set(gcc_arm_toolchain_prefix arm-none-eabi)

set(CMAKE_LIBRARY_ARCHITECTURE ${gcc_arm_toolchain_bin_path})

if(UNIX)
    set(executable_extension)
elseif(WIN32)
    set(executable_extension .exe)
endif()
    
# which compilers to use for C and C++
set(CMAKE_C_COMPILER ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-gcc${executable_extension})
set(CMAKE_CXX_COMPILER ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-g++${executable_extension})
set(CMAKE_AR ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-ar${executable_extension})
set(CMAKE_ASM_COMPILER ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-gcc${executable_extension})
# set(CMAKE_C_COMPILER_LINKER ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-ld${executable_extension})
# We must set the OBJCOPY setting into cache so that it's available to the
# whole project. Otherwise, this does not get set into the CACHE and therefore
# the build doesn't know what the OBJCOPY filepath is
set(CMAKE_OBJCOPY ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-objcopy${executable_extension} CACHE FILEPATH "The toolchain objcopy command " FORCE )
set(CMAKE_OBJDUMP ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-objdump${executable_extension} CACHE FILEPATH "The toolchain objdump command " FORCE )
set(CMAKE_SIZE ${gcc_arm_toolchain_bin_path}/${gcc_arm_toolchain_prefix}-size${executable_extension} CACHE FILEPATH "The toolchain size command " FORCE )

set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS S)
# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSTM32F722xx")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu11 -g3 -O0 -ggdb3")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,-allow-multiple-definition")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wimplicit-function-declaration")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nodefaultlibs")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=armv7e-m+fp -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -ffunction-sections -fdata-sections")

set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -x assembler-with-cpp")