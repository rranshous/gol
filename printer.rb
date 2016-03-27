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

