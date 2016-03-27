class Collection

  extend Forwardable

  def_delegator :cells, :select
  def_delegator :cells, :map

  def initialize
    self.cells = []
  end

  def << cell
    cells << cell
  end

  def each &blk
    cells.each { |c| blk.call c }
  end

  def cell location
    cells.detect { |c| c.location == location }
  end
  alias_method :[], :cell

  def dup
    super.tap do |collection|
      collection.cells = cells.map(&:dup)
    end
  end

  protected
  attr_accessor :cells
end
