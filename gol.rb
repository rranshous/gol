$: << File.absolute_path('.')

require 'cell'
require 'printer'
require 'location'
require 'collection'

require 'pry'

class Neighbors
  def initialize location, cells
    self.cells = cells
    self.location = location
  end
  def alive_count
    cells
      .select { |c| location.surrounding.include? c.location }
      .select(&:alive?)
      .count
  end
  protected
  attr_accessor :location, :cells
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
  cells.each do |cell|
    cell.alive_neighbor_count = Neighbors.new(cell.location, snapshot).alive_count
  end
  printer.print!
  gets
end
