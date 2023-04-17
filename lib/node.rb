# frozen_string_literal: true

class Node
  include Comparable

  attr_accessor :data, :left_child, :right_child

  def initialize(data, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    data <=> other.data
  end
end
