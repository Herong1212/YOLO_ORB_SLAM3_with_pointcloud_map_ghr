cmake_minimum_required(VERSION 3.17)

project(YOLO_ORB_SLAM3_with_pointcloud_map)

set(ROS_BUILD_TYPE Release)
message("Build type: " ${ROS_BUILD_TYPE})
message("")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall  -O3 -march=native ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall  -O3 -march=native")

# Check C++11 or C++0x support
include(CheckCXXCompilerFlag)
# CHECK_CXX_COMPILER_FLAG("-std=c++14" COMPILER_SUPPORTS_CXX14)
CHECK_CXX_COMPILER_FLAG("-std=c++17" COMPILER_SUPPORTS_CXX17)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)

if(COMPILER_SUPPORTS_CXX17)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    add_definitions(-DCOMPILEDWITHC17)
    message(STATUS "Using flag -std=c++17.")
elseif(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    add_definitions(-DCOMPILEDWITHC11)
    message(STATUS "Using flag -std=c++11.")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    add_definitions(-DCOMPILEDWITHC0X)
    message(STATUS "Using flag -std=c++0x.")
else()
    message(FATAL_ERROR "The compiler ${CMAKE_CXX_COMPILER} has no C++14 support. Please use a different C++ compiler.")
endif()

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../../../cmake_modules)

# set(CMAKE_PREFIX_PATH ${PROJECT_SOURCE_DIR}/../../../Thirdparty/libtorch)
set(CMAKE_PREFIX_PATH "/usr/local/lib/libtorch")

# find_package(catkin REQUIRED COMPONENTS
#     roscpp
#     std_msgs
#     sensor_msgs
#     image_transport
#     cv_bridge
#     tf
#     geometry_msgs
#     # 其他依赖项
# )

# 4.2.0
find_package(OpenCV REQUIRED)
message("OpenCV Version: " ${OpenCV_VERSION})
message("OpenCV_INCLUDE_DIRS: " ${OpenCV_INCLUDE_DIRS})
message("OpenCV_LIBRARIES: " ${OpenCV_LIBRARIES})
message("")

# 1.10.0
find_package(PCL)
message("PCL: " ${PCL_VERSION})
message("")

# 3.3.7
find_package(Eigen3 REQUIRED)
message("Eigen Version: " ${EIGEN_VERSION})
message("")

# 0.6
find_package(Pangolin REQUIRED)
message("Pangolin Version: " ${Pangolin_VERSION})
message("")

# 2.5.1
find_package(Torch REQUIRED)
message("")
message("Torch Version: " ${Torch_VERSION})
message("TORCH_INCLUDE_DIRS: " ${TORCH_INCLUDE_DIRS})
message("")

# 1.22.0，但是不是用的这个版本，是 Thirdparty 里的三方库
# find_package(Sophus REQUIRED)
# message("Sophus Version: " ${Sophus_VERSION})
message("---------------------------------------------------------")

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_SOURCE_DIR}/../../../
    ${PROJECT_SOURCE_DIR}/../../../include
    ${PROJECT_SOURCE_DIR}/../../../include/CameraModels
    ${PROJECT_SOURCE_DIR}/../../../Thirdparty/Sophus
    ${Pangolin_INCLUDE_DIRS}
    ${PCL_INCLUDE_DIRS}
    # "/usr/local/lib/libtorch/include"
    ${TORCH_INCLUDE_DIRS}
    # ${catkin_INCLUDE_DIRS}
)

set(LIBS
    ${OpenCV_LIBS}
    ${TORCH_LIBRARIES}
    ${EIGEN3_LIBS}
    ${Pangolin_LIBRARIES}
    ${PCL_LIBRARIES}
    ${PROJECT_SOURCE_DIR}/../../../Thirdparty/DBoW2/lib/libDBoW2.so
    ${PROJECT_SOURCE_DIR}/../../../Thirdparty/g2o/lib/libg2o.so
    ${PROJECT_SOURCE_DIR}/../../../lib/libORB_SLAM3.so
    -lboost_system
    # ${catkin_LIBRARIES}
)

# 更改可执行文件的输出路径
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/src)

# Node for monocular camera
add_executable(Mono src/ros_mono.cc)
target_link_libraries(Mono ${LIBS})

# Node for stereo camera
add_executable(Stereo src/ros_stereo.cc)
target_link_libraries(Stereo ${LIBS})

# Node for RGB-D camera
add_executable(RGBD src/ros_rgbd.cc)
target_link_libraries(RGBD ${LIBS})

# Node for monocular-inertial camera
add_executable(Mono_Inertial src/ros_mono_inertial.cc)
target_link_libraries(Mono_Inertial ${LIBS})

# Node for stereo-inertial camera
add_executable(Stereo_Inertial src/ros_stereo_inertial.cc)
target_link_libraries(Stereo_Inertial ${LIBS})
