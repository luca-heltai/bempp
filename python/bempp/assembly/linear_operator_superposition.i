%{
#include "assembly/linear_operator_superposition.hpp"
%}

// TODO
// %include "linear_operator_superposition_docstrings.i"

%include "assembly/linear_operator_superposition.hpp"

namespace Bempp
{
BEMPP_PYTHON_EXTEND_CLASS_TEMPLATED_ON_BASIS_AND_RESULT(LinearOperatorSuperposition);
BEMPP_PYTHON_INSTANTIATE_CLASS_TEMPLATED_ON_BASIS_AND_RESULT(LinearOperatorSuperposition);
}