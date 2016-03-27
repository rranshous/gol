require 'cell_engine'

class Cell

  ALIVE = true
  DEAD = false

  attr_accessor :location, :state

  def initialize location, state
    self.state = state
    self.location = location
    self.engine = CellEngine.new
  end

  def alive?
    self.state == ALIVE
  end

  def update cells
    if alive?
      binding.pry
    end
    engine.snapshot!
    engine.alive_neighbor_count = alive_neighbor_count(cells)
    self.state = engine.alive?
  end

  def to_s
    inspect
  end

  def inspect
    "#<Cell location:#{location} alive?:#{alive?}>"
  end

  protected

  attr_accessor :engine

  def alive_neighbor_count cells
    cells
      .select { |c| location.neighbors.include? c.location }
      .select(&:alive?)
      .count
  end
end

