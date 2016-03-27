require 'wongi-engine'
require 'patch'

class CellEngine < Wongi::Engine::Network

  def initialize
    super
    self.class.add_rules self
  end

  def alive_neighbor_count= count
    clear_to! count
    self << ["neighbors", "alive", count]
  end

  def set_alive
    self << ["me", "alive", true]
  end

  def alive?
    self.productions["alive?"].tokens.any?
  end

  private

  def clear_to! count
    #facts.each { |f| retract f }
    facts.each do |r|
      if r.subject == "neighbors" && r.predicate == "alive" && r.object > count
        puts "retracting: #{r.object}"
        retract r
      end
    end
  end

  def self.add_rules engine
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

    # add rule so we'll know if we are alive
    engine.rule "stay_alive?" do
      forall {
        # Any live cell with fewer than two live neighbours dies,
        #  as if caused by under-population.
        # Any live cell with two or three live neighbours lives on
        #  to the next generation.
        has "neighbors", "alive", 2
        #any {
        #  option { has "neighbors", "alive", 2 }
        #  option { has "neighbors", "alive", 3 }
        #}
        # Any live cell with more than three live neighbours dies,
        #  as if by over-population.
        missing "neighbors", "alive", 4
        # Any dead cell with exactly three live neighbours becomes a live cell,
        #  as if by reproduction.
        #
        # if it was not already alive than we shouldn't stay alive
        has "me", "alive", true, time: -1
      }
      make {
        gen "me", "alive", true
        action { puts "staying alive" }
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
        missing "me", "alive", true, time: -1
      }
      make {
        gen "me", "alive", true
        action { puts "becoming alive" }
      }
    end

    engine.rule "alive?" do
      forall { has "me", "alive", true }
      make { action { puts "is alive" } }
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
        has "me", "live", true, time: -1
      }
      make {
        action { retract ["me", "alive", true] }
        action { puts "becoming dead" }
      }
    end
  end
end


