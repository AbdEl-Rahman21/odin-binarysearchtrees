require_relative './lib/node'
require_relative './lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })

tree.pretty_print

if tree.balanced?
  p tree.preorder
  p tree.inorder
  p tree.postorder
end

5.times { tree.insert(rand(1..99)) }

tree.pretty_print

unless tree.balanced?
  tree.rebalance
  tree.pretty_print
  p tree.preorder
  p tree.inorder
  p tree.postorder
end
