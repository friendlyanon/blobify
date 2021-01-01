include(CMakeFindDependencyMacro)
find_dependency(BoostPFR 2)
find_dependency(magic_enum 0.7)

include("${CMAKE_CURRENT_LIST_DIR}/blobify-targets.cmake")
