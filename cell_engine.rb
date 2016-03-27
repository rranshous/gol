require 'wongi-engine'
require 'patch'
require 'pry'

class CellEngine < Wongi::Engine::Network

  def initialize
    super
    self.class.add_rules self
  end

  def alive_neighbor_count= count
    puts "setting alive neighbor count: #{count}"
    snapshot!
    clear_friend_count
    add_neighbor_facts_for count
  end

  def set_alive
    self.alive_neighbor_count = 3
  end

  def alive?
    self.productions["alive?"].tokens.any?
  end

  private

  def add_neighbor_facts_for count
    puts "adding neighbor rule: #{count}"
    self << ["neighbors", "alive", count]
  end

  def clear_friend_count
    facts
      .select { |f| f.subject == "neighbors" && f.predicate == "alive" }
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

    #engine.rule "alive?" do
    #  forall { has "me", "alive", true }
    #  make { action { puts "is alive" } }
    #end

    engine.rule "alive?" do
      forall {
        any {
          # become alive
          option { has "neighbors", "alive", 3 }

          # stay alive
          option {
            any {
              option { has "neighbors", "alive", 2 }
              option { has "neighbors", "alive", 3 }
            }

            any {
              option { has "neighbors", "alive", 2, time: -1 }
              option { has "neighbors", "alive", 3, time: -1 }
            }
          }
        }
      }
    end

    #engine.rule "become_alive?" do
    #  forall {
    #    has "neighbors", "alive", 3
    #  }
    #  make {
    #    action { puts "becoming alive" }
    #    gen "me", "alive", true
    #  }
    #end

    #engine.rule "stay_alive?" do
    #  forall {
    #    any {
    #      option { has "neighbors", "alive", 2 }
    #      option { has "neighbors", "alive", 3 }
    #    }
    #    any {
    #      option { has "neighbors", "alive", 2, time: -1 }
    #      option { has "neighbors", "alive", 3, time: -1 }
    #    }
    #  }
    #  make {
    #    action { puts "staying alive" }
    #    gen "me", "alive", true
    #  }
    #end

    #engine.rule "become_dead?" do
    #  forall {
    #    any {
    #      option { missing "neighbors", "alive", 2 }
    #      option { has "neighbors", "alive", 4 }
    #    }
    #  }
    #  make {
    #    action { puts "becoming dead" }
    #  }
    #end
  end
end


