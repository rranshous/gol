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

