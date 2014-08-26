// vi: set et ts=4 sw=2 sts=2:

#ifndef HMAT_CLUSTER_TREE_HPP
#define HMAT_CLUSTER_TREE_HPP

#include "common.hpp"
#include "simple_tree_node.hpp"
#include "bounding_box.hpp"
#include "geometry.hpp"
#include "dof_permutation.hpp"

namespace hmat {

struct ClusterTreeNodeData {

  ClusterTreeNodeData(const IndexRangeType &indexRange,
                      const BoundingBox &boundingBox);

  IndexRangeType indexRange;
  BoundingBox boundingBox;
};

template <int N = 2>
using ClusterTreeNode = SimpleTreeNode<ClusterTreeNodeData, N>;

template <int N = 2> class ClusterTree {

public:
  ClusterTree(const Geometry &geometry, int maxSize);

  const shared_ptr<const ClusterTreeNode<N>> root() const;
  const shared_ptr<ClusterTreeNode<N>> root();

  std::size_t mapOriginalDofToHMatDof(std::size_t originalDofIndex) const;
  std::size_t mapHMatDofToOriginalDof(std::size_t hMatDofIndex) const;

  std::vector<shared_ptr<const ClusterTreeNode<N>>> leafNodes() const;
  std::vector<shared_ptr<ClusterTreeNode<N>>> leafNodes();

  std::size_t numberOfDofs() const;

private:
  shared_ptr<ClusterTreeNode<N>>
  initializeClusterTree(const Geometry &geometry);
  void splitClusterTreeByGeometry(const Geometry &geometry,
                                  DofPermutation &dofPermutation, int maxSize);

  shared_ptr<ClusterTreeNode<N>> m_root;
  DofPermutation m_dofPermutation;
};
}
#include "cluster_tree_impl.hpp"

#endif
