require 'cell_engine'

class Cell

  ALIVE = 1
  DEAD = 0

  attr_accessor :location

  def initialize location, state
    self.state = state
    self.location = location
    self.engine = CellEngine.new
  end

  def alive?
    self.state == ALIVE
  end

  def update cells
    engine.snapshot!
    engine.alive_neighbor_count = alive_neighbor_count
    self.state = engine.alive?
  end

  private

  attr_accessor :state, :engine

  def alive_neighbor_count
    cells
      .select { |c| location.neighbors.include? c.location }
      .select(&:alive?)
      .count
  end
end

