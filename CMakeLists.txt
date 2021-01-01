cmake_minimum_required(VERSION 3.14)

project(blobify
        VERSION 0.0.1
        DESCRIPTION "C++17 library for all your binary de-/serialization needs"
        HOMEPAGE_URL "https://github.com/neobrain/blobify"
        LANGUAGES CXX)

if(MSVC)
  message(FATAL_ERROR
          "This library can't compile with MSVC\n"
          "See: https://github.com/friendlyanon/blobify/issues/1")
endif()

# ---- Warning guard ----

# Protect dependents from this project's warnings if the guard isn't disabled
set(blobify_warning_guard SYSTEM)
if(blobify_INCLUDE_WITHOUT_SYSTEM)
  set(blobify_warning_guard "")
endif()

# ---- Declare library ----

add_library(blobify INTERFACE)
add_library(blobify::blobify ALIAS blobify)

target_include_directories(blobify
        ${blobify_warning_guard}
        INTERFACE
        "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>")

target_compile_features(blobify INTERFACE cxx_std_17)

find_package(BoostPFR 2 REQUIRED)
find_package(magic_enum 0.7 REQUIRED)
target_link_libraries(blobify INTERFACE Boost::pfr magic_enum::magic_enum)

# ---- Install ----

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(blobify_directory "blobify-${PROJECT_VERSION}")
set(blobify_include_directory
        "${CMAKE_INSTALL_INCLUDEDIR}/${blobify_directory}")

install(DIRECTORY "${PROJECT_SOURCE_DIR}/include/"
        DESTINATION "${blobify_include_directory}"
        COMPONENT blobify_Development)

install(TARGETS blobify
        EXPORT blobifyTargets
        INCLUDES DESTINATION "${blobify_include_directory}")

write_basic_package_version_file(
        blobify-config-version.cmake
        COMPATIBILITY SameMajorVersion
        ARCH_INDEPENDENT)

set(blobify_install_cmakedir
        "${CMAKE_INSTALL_LIBDIR}/cmake/${blobify_directory}")

install(FILES
        "${PROJECT_SOURCE_DIR}/cmake/blobify-config.cmake"
        "${PROJECT_BINARY_DIR}/blobify-config-version.cmake"
        DESTINATION "${blobify_install_cmakedir}"
        COMPONENT blobify_Development)

install(EXPORT blobifyTargets
        FILE blobify-targets.cmake
        NAMESPACE blobify::
        DESTINATION "${blobify_install_cmakedir}"
        COMPONENT blobify_Development)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  include(CPack)
endif()
