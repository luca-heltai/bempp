# Needs boost: include this after boost.lookup.
if(Boost_BUILT_AS_EXTERNAL_PROJECT)
  set(depends_on Boost)
endif()
set(default_common_URL
    http://www.dune-project.org/download/2.2.1/dune-common-2.2.1.tar.gz)
set(default_common_MD5 4001d4c95f06e22ded41abeb063c561c)
set(default_geometry_URL
    http://www.dune-project.org/download/2.2.1/dune-geometry-2.2.1.tar.gz)
set(default_geometry_MD5 35bfc7656549abb2a414ecbd06108384)
set(default_grid_URL
    http://www.dune-project.org/download/2.2.1/dune-grid-2.2.1.tar.gz)
set(default_grid_MD5 21f1a53949c1d21682101552e3b5bc5c)
set(default_localfunctions_URL
    http://www.dune-project.org/download/2.2.1/dune-localfunctions-2.2.1.tar.gz)
set(default_localfunctions_MD5 49a8f85802ff5d9ed917c71181dc2fbd)
macro(_get_arguments component)
    set(keyvalues  ${component}_URL;${component}_MD5)
    cmake_parse_arguments(_ "" "${keyvalues}" "" ${Dune_ARGUMENTS})
    if(__${component}_URL AND NOT __${component}_MD5)
        message(FATAL_ERROR "${component} given a URL but no MD5 hash")
    elseif(__${component}_URL AND __${component}_MD5)
        set(prefix "__")
    else()
        set(prefix "default_")
    endif()
    set(${component}_ARGUMENTS
        URL ${${prefix}${component}_URL}
        URL_HASH MD5=${${prefix}${component}_MD5}
    )
endmacro()

set(build_args
    BUILD_IN_SOURCE 1
    BUILD_COMMAND make
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
)
macro(_file_args OUTVAR withname)
    unset(result_var)
    foreach(filename ${ARGN})
        if(EXISTS ${filename} AND NOT IS_DIRECTORY ${filename})
            list(APPEND result_var "${filename}")
        endif()
    endforeach()
    if(result_var)
        set(${OUTVAR} "--with-${withname}=\"${result_var}\"")
    endif()
endmacro()

_file_args(blas_args blas ${BLAS_LIBRARIES})
_file_args(lapack_args lapack ${LAPACK_LIBRARIES})

set(configure_args
    CC=${CMAKE_C_COMPILER}
    CFLAGS=${CMAKE_C_FLAGS}
    CXX=${CMAKE_CXX_COMPILER}
    CXXFLAGS=${CMAKE_CXX_FLAGS}
    PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH}
    --enable-shared=no
    --enable-static=yes
    --with-pic
    --disable-documentation
    --prefix=${EXTERNAL_ROOT}
    ${blas_args}
    ${lapack_args}
)

_get_arguments(common)
ExternalProject_Add(
    dune-common
    PREFIX ${EXTERNAL_ROOT}
    DEPENDS ${depends_on}
    ${common_ARGUMENTS}
    CONFIGURE_COMMAND ./configure ${configure_args}
    INSTALL_COMMAND make install
    ${build_args}
)

_get_arguments(geometry)
ExternalProject_Add(
    dune-geometry
    DEPENDS dune-common
    PREFIX ${EXTERNAL_ROOT}
    ${geometry_ARGUMENTS}
    CONFIGURE_COMMAND ./configure ${configure_args}
    INSTALL_COMMAND make install
    ${build_args}
)

find_program(PATCH_EXECUTABLE patch REQUIRED)
_get_arguments(grid)
ExternalProject_Add(
    dune-grid
    DEPENDS dune-geometry dune-common
    PREFIX ${EXTERNAL_ROOT}
    ${grid_ARGUMENTS}
    CONFIGURE_COMMAND ./configure ${configure_args}
    INSTALL_COMMAND make install
    ${build_args}
)
ExternalProject_Add_Step(dune-grid
    PATCH
    COMMAND
        ${PATCH_EXECUTABLE} -p0
            < ${PROJECT_SOURCE_DIR}/installer/patches/dune-grid_yaspgrid.patch
    COMMAND
        ${PATCH_EXECUTABLE} -p0
            < ${PROJECT_SOURCE_DIR}/installer/patches/dune-grid_dgfparser.patch
    WORKING_DIRECTORY ${EXTERNAL_ROOT}/src
    DEPENDS
        ${PROJECT_SOURCE_DIR}/installer/patches/dune-grid_dgfparser.patch
        ${PROJECT_SOURCE_DIR}/installer/patches/dune-grid_yaspgrid.patch
    DEPENDEES download
    DEPENDERS configure
)

_get_arguments(localfunctions)
ExternalProject_Add(
    dune-localfunctions
    DEPENDS dune-grid dune-geometry dune-common
    PREFIX ${EXTERNAL_ROOT}
    ${localfunctions_ARGUMENTS}
    CONFIGURE_COMMAND ./configure ${configure_args}
    PATCH_COMMAND
        ${CMAKE_COMMAND} -DROOT=${EXTERNAL_ROOT}/src/dune-localfunctions
            -P ${CURRENT_LOOKUP_DIRECTORY}/patch-localfunctions.cmake
    INSTALL_COMMAND make install
    ${build_args}
)

ExternalProject_Add(
    dune-foamgrid
    DEPENDS dune-grid dune-geometry dune-common dune-localfunctions
    PREFIX ${EXTERNAL_ROOT}
    URL ${PROJECT_SOURCE_DIR}/contrib/dune/dune-foamgrid
    PATCH_COMMAND
       ${CMAKE_COMMAND} -E copy_if_different
                        ${CURRENT_LOOKUP_DIRECTORY}/foamgrid-install.cmake
                        ${EXTERNAL_ROOT}/src/dune-foamgrid/CMakeLists.txt
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNAL_ROOT}
)

# This file helps to create a fake dune project
# It answers the question posed by the duneproject script, including the subsidiary
# "this directory already exists..."
file(
  WRITE ${EXTERNAL_ROOT}/src/bempp.dune.input
  "dune-bempp
dune-common dune-geometry dune-grid dune-localfunctions
1
me@me
y
y
"
)

# Create fake dune project, with the sole goal of generating a config.h file!
# First, generate a new project
ExternalProject_Add(
    dune-bempp
    DEPENDS dune-foamgrid dune-grid dune-geometry dune-common dune-localfunctions
    PREFIX ${EXTERNAL_ROOT}
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ./configure ${configure_args}
    INSTALL_COMMAND
        ${CMAKE_COMMAND} -E copy_if_different
               ${EXTERNAL_ROOT}/src/dune-bempp/config.h
               ${EXTERNAL_ROOT}/include/dune_config.h
    ${build_args}
)
ExternalProject_Add_Step(dune-bempp
    CREATE_PROJECT
    COMMAND dune-common/bin/duneproject < bempp.dune.input
    COMMAND dune-common/bin/dunecontrol --module=dune-bempp autogen
    WORKING_DIRECTORY ${EXTERNAL_ROOT}/src
    DEPENDERS configure
)

# Rerun cmake to capture new dune install
add_recursive_cmake_step(dune-bempp
    PACKAGE_NAME Dune
    FOUND_VAR Dune_FOUND
    DEPENDEES install
)
