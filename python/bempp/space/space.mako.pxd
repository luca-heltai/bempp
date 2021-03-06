<%
from data_types import dtypes, scalar_cython_type, real_cython_type

from space import spaces

def declare_class(text):
    return 'c_{0} "Bempp::{0}"[BASIS]'.format(text)
%>
from bempp.utils.armadillo cimport Mat
from libcpp cimport complex as ccomplex, bool as cbool
from libcpp.string cimport string
from bempp.utils cimport shared_ptr, complex_float,complex_double
from bempp.grid.grid cimport Grid, c_Grid

cdef extern from "bempp/space/py_space_variants.hpp":
    cdef cppclass c_Space "Bempp::Space" [BASIS]:
        c_Space(const shared_ptr[c_Grid]&)
        c_Space(const c_Space[BASIS]&)
        shared_ptr[const c_Grid] grid() const

# Declares complex type explicitly.
# Cython 0.20 will fail if templates are nested more than three-deep,
# as in shared_ptr[ c_Space[ complex[float] ] ]
cdef extern from "bempp/utils/py_types.hpp":
% for ctype in dtypes.values():
%     if 'complex'  in ctype:
    ctypedef struct ${ctype}
%     endif
% endfor



% for class_name, description in spaces.items():
cdef extern from "${description['header']}":
    cdef cppclass ${class_name | declare_class}:
%   if description['implementation'] == 'grid_only':
        ${'c_' + class_name}(const shared_ptr[c_Grid] &_grid)
%   elif description['implementation'] == 'polynomial':
        ${'c_' + class_name}(const shared_ptr[c_Grid] &_grid, int order)
%   endif
% endfor

cdef extern from "bempp/space/py_space_variants.hpp" namespace "Bempp":
    cdef cppclass SpaceVariants:
        SpaceVariants()
        void set[T](const shared_ptr[T] &_in)
        void set[T](const shared_ptr[const T] &_in)
        # void reset[T](const shared_ptr[T] &_in)
        string dtype() const
        shared_ptr[const c_Grid] grid() const
        cbool isCompatible(const SpaceVariants&)
        cbool is_same "isSame"(const SpaceVariants&)
        int codomainDimension() const
        int domainDimension() const
        unsigned long globalDofCount() const
        unsigned long flatLocalDofCount() const 

    cdef shared_ptr[c_Space[BASIS]] _py_get_space_ptr[BASIS](const SpaceVariants& space_variant)
% for pybasis,cybasis in dtypes.items():
    cdef Mat[${real_cython_type(cybasis)}] _py_space_get_global_dof_interp_points_${pybasis} "Bempp::_py_space_get_global_dof_interp_points<${cybasis}>"(const SpaceVariants& space_variant)
    cdef Mat[${real_cython_type(cybasis)}] _py_space_get_global_dof_normals_${pybasis} "Bempp::_py_space_get_global_dof_normals<${cybasis}>"(const SpaceVariants& space_variant)
% endfor

cdef class Space:
    cdef:
        SpaceVariants impl_
        unsigned int _order
    cpdef cbool is_compatible(self, Space other)

# Now we define derived types for each space.
# This is a flat hierarchy. It does not attempt to redeclare the C++ hierarchy.
% for class_name, description in spaces.items():
cdef class ${class_name}(Space):
    pass
% endfor
