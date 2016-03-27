class Location
  attr_reader :x, :y
  def initialize x, y
    self.x = x
    self.y = y
  end
  def surrounding
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
