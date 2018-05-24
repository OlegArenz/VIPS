cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(VIPS)

SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake/Modules/" ${CMAKE_MODULE_PATH})
add_definitions(-std=c++11)

set(Python_ADDITIONAL_VERSIONS 3.4)
find_package(PythonLibs 3 REQUIRED)
find_package(Threads REQUIRED)
find_package(OpenMP REQUIRED)

if (OPENMP_FOUND)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
execute_process(COMMAND swig -Wall -c++ -python VIPS_PythonWrapper.i WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND swig -Wall -c++ -python MMD.i WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

#include_directories(${PYTHON_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ~/libs/armadillo/include ~/libs/OpenBlas/include ~/libs/nlopt/include /shared/apps/python/3.5.4/include/python3.5m /shared/apps/python/3.5.4/lib/python3.5/site-packages/numpy-1.13.1-py3.5-linux-x86_64.egg/numpy/core/include)
include_directories(${PYTHON_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ~/libs/armadillo/include ~/libs/OpenBlas/include ~/libs/nlopt/include)
link_directories(~/libs/OpenBlas/lib ~/libs/nlopt/lib)

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../")

add_library(_VIPS_PythonWrapper SHARED
     VIPS_PythonWrapper_wrap.cxx VIPS_PythonWrapper.cpp VIPS_PythonWrapper.h
     VIPS.cpp VIPS.h
     SampleDatabase.cpp SampleDatabase.h
     VIPS_Model.cpp VIPS_Model.h
     GMM.cpp GMM.h
     More.cpp More.h
     Reps.cpp Reps.h
     Utils.cpp Utils.h
     )
SET_TARGET_PROPERTIES(_VIPS_PythonWrapper PROPERTIES PREFIX "")
target_link_libraries(_VIPS_PythonWrapper ${CMAKE_THREAD_LIBS_INIT} ${PYTHON_LIBRARIES} openblas gfortran nlopt m)
install (TARGETS _VIPS_PythonWrapper DESTINATION "python/cppWrapper")
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/VIPS_PythonWrapper.py DESTINATION "python/cppWrapper")

add_library(_MMD SHARED MMD_wrap.cxx MMD.cpp MMD.h)
SET_TARGET_PROPERTIES(_MMD PROPERTIES PREFIX "")
target_link_libraries(_MMD ${CMAKE_THREAD_LIBS_INIT} ${PYTHON_LIBRARIES} openblas gfortran)
install (TARGETS _MMD DESTINATION "python/cppWrapper")
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/MMD.py DESTINATION "python/cppWrapper")
