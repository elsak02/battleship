class Ship
  attr_accessor :location, :remaining_shot, :size

  def initialize(size, location)
    @size = size
    @location = location
    @remaining_shot = size
  end
end
