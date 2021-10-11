class Ship
  attr_accessor :location

  def initialize(size, location)
    @size = size
    @location = location
  end

  # def check_size?
  #   location.length == size
  # end

  # def right_direction?
  #   array = location.join.chars
  #   if size == 3
  #     [array[0], array[2], array[4]].uniq.count == 1 || [array[1], array[3], array[5]].uniq.count == 1
  #   else
  #     [array[0], array[2], array[4], array[6]].uniq.count == 1 || [array[1], array[3], array[5], array[7]].uniq.count == 1
  #   end
  # end

  # def find_indexes
  #   indexes = []
  #   location.each do |coordinate|
  #     index_row = Grid::ROW_LABEL.find_index(coordinate.chars[0])
  #     index_column = coordinate.chars[1].to_i - 1
  #   indexes << [index_row, index_column]
  #   end
  #   indexes
  # end
end
