cmake_minimum_required(VERSION 3.13)
project(fez-dot
    VERSION 0.1.1
    LANGUAGES CXX)

add_subdirectory(src)

install(TARGETS fez-dot RUNTIME DESTINATION bin)
install(FILES package/fez-dot.desktop DESTINATION share/applications)