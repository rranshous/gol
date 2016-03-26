class Cell
  attr_accessor location
  def alive?
  end
end

class Cell < Wongi::Engine
  attr_accessor :neighbors

  def initialize
    super
    add_rules self
    self.neighbors = []
  end

  def alive!
    self << ["me", "alive", true]
  end

  def dead!
    self.retract ["me", "alive", true]
  end

  def alive?
  end

  def dead?
  end

  def update_state
    self.snapshot!
    1.upto(8).each do |i|
      self.retract ["neighbors", "alive", i]
    end
    self << ["neighbors", "alive", neighbors.length]
  end

  private

  def self.add_rules engine
    # fact format
    # [ "neighbors", "alive", 3 ]
    # if there are three than there are two, one, etc
    engine.rule "infered counts" do
      forall { has "neighbors", "alive", :Count }
      make { action { |token|
        1.upto(token[:Count]) { |i| gen "neighbors", "alive", i }
      } }
    end
    # add rule so we'll know if we are alive
    engine.rule "stay_alive?" do
      forall {
        # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        # Any live cell with two or three live neighbours lives on to the next generation.
        any {
          has "neighbors", "alive", 2
          has "neighbors", "alive", 3
        }
        # Any live cell with more than three live neighbours dies, as if by over-population.
        missing "neighbors", "alive", 4
        # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
      }
      make {
        gen "me", "alive", true
      }
    end
    engine.rule "become_alive?" do
      forall {
        # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        # Any live cell with two or three live neighbours lives on to the next generation.
        # Any live cell with more than three live neighbours dies, as if by over-population.
        # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        has "neighbors", "alive", 3
        missing "neighbors", "alive", 4
      }
      make {
        gen "me", "alive", true
      }
    end
    engine.rule "alive?" do
      forall { has "me", "alive", true }
    end
    engine.rule "become_dead?" do
      forall {
        # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        missing "neighbors", "alive", 2
        # Any live cell with two or three live neighbours lives on to the next generation.
        # Any live cell with more than three live neighbours dies, as if by over-population.
        has "neighbors", "alive", 4
        # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
      }
      make {
        retract "me", "alive", true
      }
    end
    engine.rule "dead?" do
      forall { missing "me", "alive", true }
    end
  end
end


