cmake_minimum_required(VERSION 3.14)

project(blobify_tests CXX)

set(blobify_INCLUDE_WITHOUT_SYSTEM YES CACHE INTERNAL "")
include(FetchContent)
FetchContent_Declare(blobify SOURCE_DIR "${PROJECT_SOURCE_DIR}/..")
FetchContent_MakeAvailable(blobify)

include(../cmake/warnings.cmake)
target_compile_options(blobify INTERFACE ${PROJECT_WARNINGS})

enable_testing()

function(create_test name)
  add_executable("${name}" "${name}.cpp")
  target_link_libraries("${name}" PRIVATE blobify::blobify)
  target_compile_features("${name}" PRIVATE cxx_std_17)
  add_test(NAME "${name}" COMMAND "${name}" ${ARGN})
endfunction()

create_test(simple_test)
create_test(bmp test.bmp WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
