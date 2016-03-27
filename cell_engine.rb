require 'wongi-engine'
require 'patch'

class CellEngine < Wongi::Engine::Network

  def initialize
    super
    self.class.add_rules self
  end

  def alive_neighbor_count= count
    clear!
    binding.pry if count > 0
    self << ["neighbor", "alive", count]
  end

  def alive?
    self.productions["alive?"].tokens.any?
  end

  private

  def clear!
    facts.each { |r| retract r }
  end

  def self.add_rules engine
    # fact format
    # [ "neighbors", "alive", 3 ]
    # if there are three than there are two, one, etc
    engine.rule "infered counts" do
      forall { has "neighbors", "alive", :Count }
      make { action { |token|
        puts "adding neighbors"
        1.upto(token[:Count]) { |i| gen "neighbors", "alive", i }
      } }
    end
    # add rule so we'll know if we are alive
    engine.rule "stay_alive?" do
      forall {
        # Any live cell with fewer than two live neighbours dies,
        #  as if caused by under-population.
        # Any live cell with two or three live neighbours lives on
        #  to the next generation.
        any {
          option { has "neighbors", "alive", 2 }
          option { has "neighbors", "alive", 3 }
        }
        # Any live cell with more than three live neighbours dies,
        #  as if by over-population.
        missing "neighbors", "alive", 4
        # Any dead cell with exactly three live neighbours becomes a live cell,
        #  as if by reproduction.
      }
      make {
        gen "me", "alive", true
      }
    end
    engine.rule "become_alive?" do
      forall {
        # Any live cell with fewer than two live neighbours dies,
        #  as if caused by under-population.
        # Any live cell with two or three live neighbours lives on
        #  to the next generation.
        # Any live cell with more than three live neighbours dies,
        #  as if by over-population.
        # Any dead cell with exactly three live neighbours becomes a live cell,
        #  as if by reproduction.
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
        # Any live cell with fewer than two live neighbours dies,
        #  as if caused by under-population.
        missing "neighbors", "alive", 2
        # Any live cell with two or three live neighbours lives on
        #  to the next generation.
        # Any live cell with more than three live neighbours dies,
        #  as if by over-population.
        has "neighbors", "alive", 4
        # Any dead cell with exactly three live neighbours becomes a live cell,
        #  as if by reproduction.
      }
      make {
        action { retract "me", "alive", true }
      }
    end
  end
end


