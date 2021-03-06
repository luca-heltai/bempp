<%
codims = [('0','codim_zero'),('1','codim_one'),('2','codim_two')]
%>

from cython.operator cimport dereference as deref
from cython cimport address
from bempp.utils cimport unique_ptr
from bempp.grid.codim_template cimport codim_zero,codim_one,codim_two

% for (codim,codim_template) in codims:

from bempp.grid.geometry cimport Geometry${codim}

cdef class Entity${codim}:

    cpdef size_t level(self):
        return deref(self.impl_).level()

    cpdef Geometry${codim} _geometry(self):
        cdef Geometry${codim} g = Geometry${codim}()
        g.impl_= address(deref(self.impl_).geometry())
        g._entity = self
        return g

    property geometry:
        """Return the geometry of the entity"""
        def __get__(self):
            return self._geometry()
% endfor


