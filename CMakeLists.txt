cmake_minimum_required(VERSION 3.13)
project(dot
        VERSION 1.0
        LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Widgets Quick QuickControls2 REQUIRED)

add_executable(${PROJECT_NAME}
        src/main.cpp
        qml/qml.qrc
        shader/shader.qrc
        src/dot_fbo.cpp src/dot_fbo.hpp
        src/dot_render.cpp src/dot_render.hpp)

target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME}
        PRIVATE Qt5::Core Qt5::Widgets Qt5::Quick Qt5::QuickControls2)

# install

install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION bin)