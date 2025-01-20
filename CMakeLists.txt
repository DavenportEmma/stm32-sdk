cmake_minimum_required(VERSION 3.27.1)

project(${project_name} C ASM CXX)

set(CMAKE_EXECUTABLE_SUFFIX .elf)

include(cmake/python.cmake)

include(cmake/kconfig/kconfig.cmake)

genconfig()

include(cmake/kconfig/parseconfig.cmake)