# frozen_string_literal: true

require_relative './node'

class Tree
  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    if node.right
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false)
    end
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    return unless node.left

    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true)
  end

  def insert(value, node = root)
    return nil if node.data == value

    if node.data > value
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = root)
    if node.data == value
      node = delete_helper(node)
    elsif node.data > value
      node.left = delete(value, node.left)
    else
      node.right = delete(value, node.right)
    end

    node
  end

  def find(value, node = root)
    return nil if node.nil?

    return node if node.data == value

    node.data > value ? find(value, node.left) : find(value, node.right)
  end

  def level_order
    array = [root]

    array.each do |node|
      yield(node)

      array.push(node.left) unless node.left.nil?
      array.push(node.right) unless node.right.nil?
    end
  end

  def level_order_rec(array = [root], &block)
    return if array.empty?

    node = array[0]

    array.push(node.left) unless node.left.nil?
    array.push(node.right) unless node.right.nil?
    array.shift

    block.call(node)

    level_order_rec(array, &block)
  end

  def preorder(node = root, &block)
    return preorder_arr unless block_given?

    block.call(node)

    preorder(node.left, &block) unless node.left.nil?
    preorder(node.right, &block) unless node.right.nil?
  end

  def inorder(node = root, &block)
    return inorder_arr unless block_given?

    inorder(node.left, &block) unless node.left.nil?

    block.call(node)

    inorder(node.right, &block) unless node.right.nil?
  end

  def postorder(node = root, &block)
    return postorder_arr unless block_given?

    postorder(node.left, &block) unless node.left.nil?
    postorder(node.right, &block) unless node.right.nil?

    block.call(node)
  end

  def height(node = root, max = 0, steps = 0)
    return -1 if node.nil?

    steps += 1
    max = height(node.left, max, steps) unless node.left.nil?
    steps -= 1

    steps += 1
    max = height(node.right, max, steps) unless node.right.nil?
    steps -= 1

    max = steps if steps > max

    max
  end

  def depth(node = root, current_node = root, steps = 0)
    return nil if node.nil? || find(node.value).nil?
    return steps if node == current_node

    steps += 1
    steps = depth(node, current_node.left, steps) unless current_node.left.nil?

    return steps if steps.positive?

    steps -= 1

    steps += 1
    steps = depth(node, current_node.right, steps) unless current_node.right.nil?

    return steps if steps.positive?

    steps - 1
  end

  def balanced?(node = root, is_balanced: true)
    return false if (height(node.left) - height(node.right)).abs > 1

    is_balanced = balanced?(node.left) unless node.left.nil?

    return is_balanced unless is_balanced

    is_balanced = balanced?(node.right) unless node.right.nil?

    return is_balanced unless is_balanced

    is_balanced
  end

  def rebalance
    self.root = build_tree(inorder)
  end

  private

  attr_accessor :root

  def build_tree(array)
    return nil if array.empty?

    root = Node.new(array[array.length / 2])

    root.left = build_tree(array.take(array.length / 2))
    root.right =
      build_tree(array.difference(array.take((array.length / 2) + 1)))

    root
  end

  def delete_helper(node)
    if node.left.nil? && node.right.nil?
      node = nil
    elsif !node.left.nil? && !node.right.nil?
      node.data = min(node.right).data
      node.right = delete(node.data, node.right)
    else
      node = node.left.nil? ? node.right : node.left
    end

    node
  end

  def min(node)
    node = node.left until node.left.nil?

    node
  end

  def preorder_arr(node = root, arr = [])
    arr.push(node.data)

    preorder_arr(node.left, arr) unless node.left.nil?
    preorder_arr(node.right, arr) unless node.right.nil?

    arr
  end

  def inorder_arr(node = root, arr = [])
    inorder_arr(node.left, arr) unless node.left.nil?

    arr.push(node.data)

    inorder_arr(node.right, arr) unless node.right.nil?

    arr
  end

  def postorder_arr(node = root, arr = [])
    postorder_arr(node.left, arr) unless node.left.nil?
    postorder_arr(node.right, arr) unless node.right.nil?

    arr.push(node.data)
  end
end
