# Find Python 3 interpreter
find_package(Python3 REQUIRED COMPONENTS Interpreter)

# Set the Python interpreter to a variable
set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE})

# Print the Python interpreter path
message(STATUS "Found Python: ${PYTHON_EXECUTABLE}")
