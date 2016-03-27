$: << File.absolute_path('.')

require 'cell'
require 'printer'
require 'location'
require 'collection'
require 'neighbors'

require 'pry'

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
  cells.map do |cell|
    [cell, Neighbors.new(cell.location, snapshot).alive_count]
  end.each do |(cell, alive_count)|
    cell.alive_neighbor_count = alive_count
  end
  printer.print!
  gets
end
