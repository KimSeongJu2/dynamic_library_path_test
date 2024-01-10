cmake_minimum_required(VERSION 3.6)

add_library(
    lib_serial_so
    SHARED
    IMPORTED
    GLOBAL
)

set_target_properties(lib_serial_so PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libserialport.so)
