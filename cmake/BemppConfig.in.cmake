# - Config file for the BEM++ package
set(Bempp_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")
if(NOT Bempp_BINARY_DIR)
    message(STATUS "Linking to BEM++ package in ${Bempp_CMAKE_DIR}")
endif()
if(NOT TARGET libbempp AND NOT Bempp_BINARY_DIR)
    include("${Bempp_CMAKE_DIR}/BemppTargets.cmake")
endif()

list(APPEND CMAKE_MODULE_PATH "@BEMPP_CMAKE_MODULE_PATH@")
set(BEMPP_LIBRARY libbempp)
set(BEMPP_INCLUDE_DIRS @ALL_INCLUDE_DIRS@)
set(BEMPP_DIRICHLET_TUTOTIAL tutorial_dirichlet)
set(BEMPP_PYTHON_INCLUDE_DIRS @PYTHON_INCLUDE_DIRS@ @NUMPY_INCLUDE_DIRS@)
set(BEMPP_CXX_FLAGS "@CXX11_FLAGS@ @BLAS_CMAKE_C_FLAGS@")
set(BEMPP_CXX_FLAGS "${BEMPP_CXX_FLAGS} @ARMADILLO_CXX_FLAGS@ @ORIGINAL_CXX_FLAGS@")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${BEMPP_CXX_FLAGS}")
if(NOT "@BEMPP_PREFIX_PATH@" STREQUAL "" AND EXISTS "@BEMPP_PREFIX_PATH@")
    list(APPEND CMAKE_PREFIX_PATH @BEMPP_PREFIX_PATH@)
endif()
if(NOT "@CMAKE_PREFIX_PATH@" STREQUAL "")
    list(APPEND CMAKE_PREFIX_PATH @CMAKE_PREFIX_PATH@)
endif()

find_package(Boost @Boost_MAJOR_VERSION@.@Boost_MINOR_VERSION@ REQUIRED)
find_package(Armadillo REQUIRED)
find_package(TBB REQUIRED)
find_package(Dune REQUIRED COMPONENTS geometry grid localfunctions)
if(@WITH_ALUGRID@)
    find_package(ALUGrid)
endif()
find_package(Trilinos)
