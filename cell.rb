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

  def set_alive
    self.engine.set_alive
    self.state = ALIVE
  end

  def alive?
    self.state == ALIVE
  end

  def alive_neighbor_count= count
    puts "cell: #{self} :: #{count}"
    engine.alive_neighbor_count = count
    self.state = engine.alive?
  end

  def to_s
    inspect
  end

  def inspect
    "#<Cell location:#{location} alive?:#{alive?}>"
  end

  def dup
    self.class.new(location, state).tap do |obj|
      obj.engine = CellEngine.new
      engine.facts.each do |fact|
        obj.engine << fact
      end
    end
  end

  protected

  attr_accessor :engine
end

