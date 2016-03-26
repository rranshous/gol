require 'wongi-engine'
require 'pry'

class Collection
  def initialize
    self.cells = {}
  end
  def << cell
    cells[cell.location] = cell
  end
  def each &blk
    cells.each { |c| blk.call c }
  end
  private
  attr_accessor cells
end

class States
  def initialize cells
    self.cells = cells
  end
  def [] location
    cell(location).alive?
  end
  private
  attr_accessor :cells
  def cell location
    cells.detect { |c| c.location == location }
  end
end

class Location
  attr_accessor :x, :y
  def initialize x, y
    self.x = y
    self.y = y
  end
  def == location
    self.x == location.x && self.y == location.y
  end
end

class Printer

  def initialize cells, size
    self.cells = cells
    self.width = self.height = size
  end

  def print
    self.each_cell do |x, y, cell|
      if cell.alive?
        print "[X]"
      else
        print "[ ]"
      end
    end
  end

  private

  attr_accessor cells, width, height

  def each_cell &blk
    0.upto(height).each { |y| 0.upto(width).each { |x|
      blk.call x, y, cells[[x, y]]
    } }
  end
end

board_size = 10
cells = Collection.new
0.upto(board_size).each {|y| 0.upto(board_size) { |x|
  location = Location.new x, y
  cells << Cell.new(location, false)
} }
printer = Printer.new cells, board_size

loop do
  printer.print
  states = States.new cells
  cells.each { |c| c.update states }
end
