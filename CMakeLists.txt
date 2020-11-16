cmake_minimum_required(VERSION 3.13)
project(dot
    VERSION 1.0
    LANGUAGES CXX)

add_subdirectory(src)

install(TARGETS dot RUNTIME DESTINATION bin)
install(FILES package/dot.desktop DESTINATION share/applications)