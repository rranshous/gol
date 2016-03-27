$: << File.absolute_path('.')

require 'cell'

require 'pry'

class Collection
  extend Forwardable
  def_delegator :cells, :select
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

class Location
  attr_reader :x, :y
  def initialize x, y
    self.x = x
    self.y = y
  end
  def neighbors
    [
      self.class.new(x-1, y),
      self.class.new(x+1, y),

      self.class.new(x,   y-1),
      self.class.new(x-1, y-1),
      self.class.new(x+1, y-1),

      self.class.new(x,   y+1),
      self.class.new(x-1, y+1),
      self.class.new(x+1, y+1)
    ]
  end
  def == location
    self.x == location.x && self.y == location.y
  end
  def to_s
    inspect
  end
  def inspect
    "#<Location x:#{x} y:#{y}>"
  end
  protected
  attr_accessor :x, :y
end

class Printer

  def initialize cells, size
    self.cells = cells
    self.width = self.height = size
  end

  def print!
    puts
    0.upto(height).each { |y|
      0.upto(width).each { |x|
        cell = cells[Location.new(x, y)]
        if cell.alive?
          print "[X]"
        else
          print "[ ]"
        end
      }
      puts
    }
  end

  private
  attr_accessor :cells, :width, :height
end

make_alive = [[0,0],[0,1],[1,0],[1,1],[2,2],[3,2],[2,3],[3,3]] +\
             [[4,3],[9,6],[9,7],[8,5]]
BOARD_SIZE = 10
cells = Collection.new
0.upto(BOARD_SIZE).each {|y| 0.upto(BOARD_SIZE) { |x|
  location = Location.new x, y
  cells << cell = Cell.new(location, Cell::DEAD)

  if make_alive.include?([x,y])
    puts "gol [#{cell}] alive: #{x}:#{y}"
    cell.set_alive
  end
} }
printer = Printer.new cells, BOARD_SIZE
printer.print!
gets

loop do
  snapshot = cells.dup
  cells.each { |c| c.update snapshot }
  printer.print!
  gets
end
