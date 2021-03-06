set(makoes py_types.mako.hpp py_utils.mako.hpp
    parameter_list.mako.pxd parameter_list.mako.pyx
    __init__.mako.pxd armadillo.mako.pxd armadillo.mako.pyx shared_ptr.mako.pxd
    unique_ptr.mako.pxd enum_types.mako.pxd enum_types.mako.pyx)

mako_files(${makoes}
    OUTPUT_FILES makoed
    DESTINATION "${PYTHON_BINARY_DIR}/bempp/include/bempp/utils/"
    TARGETNAME bempp.utils-mako
)


split_list(sources headers makoed ".*\\.pyx")


install_python(FILES ${headers} 
               DESTINATION bempp/include/bempp/utils)

add_python_module(bempp.utils
    __init__.py data_types.py byte_conversion.py ${sources} 
    TARGETNAME bempp.utils
    CPP
    LIBRARIES libbempp
)

add_dependencies(cython-headers bempp.utils-mako)
add_dependencies(bempp.utils cython-headers)
