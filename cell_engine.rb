require 'wongi-engine'
#require 'patch'

class CellEngine < Wongi::Engine::Network

  def initialize
    super
    self.class.add_rules self
  end

  def alive_neighbor_count= count
    snapshot!
    clear_to! count
    self << ["neighbors", "alive", count]
  end

  def set_alive
    snapshot!
    self << ["me", "alive", true]
  end

  def alive?
    self.productions["alive?"].tokens.any?
  end

  def snapshot!
    super
  end

  private

  def clear_to! count
    facts
      .select { |f| f.subject == "neighbors" && f.predicate == "alive" }
      .select { |f| f.object > count }
      .sort_by { |f| f.object }.reverse
      .each { |f| puts "retracting: #{f}";retract f }
  end

  def self.add_rules engine

    # GOL rules from wikipedia:
    # Any live cell with fewer than two live neighbours dies,
    #  as if caused by under-population.
    # Any live cell with two or three live neighbours lives on
    #  to the next generation.
    # Any live cell with more than three live neighbours dies,
    #  as if by over-population.
    # Any dead cell with exactly three live neighbours becomes a live cell,
    #  as if by reproduction.
    #
    # fact format
    # [ "neighbors", "alive", 3 ]
    # if there are three than there are two, one, etc
    engine.rule "infered counts" do
      forall { has "neighbors", "alive", :Count }
      make { action { |token|
        if token[:Count] > 1
          self << ["neighbors", "alive", token[:Count] - 1]
        end
      } }
    end

    engine.rule "alive?" do
      forall { has "me", "alive", true }
      #make { action { puts "is alive" } }
    end

    engine.rule "become_alive?" do
      forall {
        has "neighbors", "alive", 3
        missing "neighbors", "alive", 4
        #missing "me", "alive", true, time: -1 # KILLING IT
      }
      make {
        #action { puts "becoming alive" }
        gen "me", "alive", true
      }
    end

    engine.rule "become_dead?" do
      forall {
        missing "neighbors", "alive", 2
        has "neighbors", "alive", 4
        #has "me", "alive", true, time: -1 # possibly killing it
      }
      make {
        #action { puts "becoming dead" }
        action { retract ["me", "alive", true] }
      }
    end
  end
end


