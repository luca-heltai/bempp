#ifndef bempp_discrete_boundary_operator_cache_hpp
#define bempp_discrete_boundary_operator_cache_hpp

#include "../common/common.hpp"
#include "../common/shared_ptr.hpp"
#include <boost/scoped_ptr.hpp>

namespace Bempp
{

template <typename ResultType> class DiscreteBoundaryOperator;
template <typename BasisFunctionType, typename ResultType> class AbstractBoundaryOperator;
template <typename BasisFunctionType, typename ResultType> class Context;

/** \ingroup discrete_boundary_operators
 *  \brief Cache of discrete boundary operators.
 */
template <typename BasisFunctionType, typename ResultType>
class DiscreteBoundaryOperatorCache
{
public:
    /** \brief Constructor. */
    DiscreteBoundaryOperatorCache();

    /** \brief Destructor. */
    ~DiscreteBoundaryOperatorCache();

    /** \brief Return the weak form of the operator \p op.
     *
     *  This function first checks whether the weak form of \p op is already
     *  stored in the DiscreteBoundaryOperatorCache object. If it is, it is
     *  returned. Otherwise the weak form is assembled from scratch, possible
     *  stored in cache (if the operator \p op is cacheable) and returned to
     *  the caller. */
    shared_ptr<const DiscreteBoundaryOperator<ResultType> >
    getWeakForm(const Context<BasisFunctionType, ResultType>& context,
                const AbstractBoundaryOperator<BasisFunctionType, ResultType>& op) const;

private:
    /** \cond PRIVATE */
    struct Impl;
    boost::scoped_ptr<Impl> m_impl;
    /** \endcond */
};

} // namespace Bempp

#endif
