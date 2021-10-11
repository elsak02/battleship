require_relative "./grid.rb"
require_relative "./ship.rb"

class Game
  attr_reader :grid_player_1, :grid_player_2

  def initialize
    @grid_player_1 = Grid.new
    @grid_player_2 = Grid.new
  end

  def run
    welcome!
    set_up!(@grid_player_1, 3)
    set_up!(@grid_player_1, 4)
    set_up!(@grid_player_2, 3)
    set_up!(@grid_player_2, 4)
  end

  def welcome!
    puts "Welcome to the battleship game !"
    puts
    puts "You have two ships to place on the board game."
    puts "The small one is three units long and the largest one is four units long."
    puts
  end

  def set_up!(grid, size)
    grid.print_board
    coordinates = []
    loop do
     puts "Please enter the coordinates of your ship (#{size} units long). Write the #{size} coordinates as in this example A1 A2 A3 #{"A4" if size == 4}."
     coordinates = gets.chomp.split
     input_validated?(grid, coordinates, size) ? break : error_message(grid, coordinates, size)
    end
     ship = Ship.new(size, coordinates)
     grid.place_ship(ship)
     grid.print_board
  end

  private

  def error_ship_size(size)
    puts "The ship must be #{size} units size." if coordinates.length != size
  end

  def input_validated?(grid, coordinates, size)
    return false unless right_size?(coordinates, size) && right_direction?(coordinates, size)

    grid.find_indexes(coordinates).each do |index_pair|
      return false unless grid.free?(index_pair[0], index_pair[1]) && grid.inbound?(index_pair[0], index_pair[1])
    end

    true
  end

  def right_size?(coordinates, size)
    coordinates.length == size
  end

  def right_direction?(coordinates, size)
    array = coordinates.join.chars
    if size == 3
      [array[0], array[2], array[4]].uniq.count == 1 || [array[1], array[3], array[5]].uniq.count == 1
    else
      [array[0], array[2], array[4], array[6]].uniq.count == 1 || [array[1], array[3], array[5], array[7]].uniq.count == 1
    end
  end

  def error_message(grid, coordinates, size)
    puts "The ship should be of the right size" unless right_size?(coordinates, size)
    puts "The ship should be placed horizontally or vertically" unless right_direction?(coordinates, size)
    grid.find_indexes(coordinates).each do |index_pair|
      return puts "The ship should be placed within the grid bounds" unless grid.inbound?(index_pair[0], index_pair[1])
      return  puts "There is already a ship in #{Grid::ROW_LABEL[index_pair[0]]}#{index_pair[1] + 1}" unless grid.free?(index_pair[0], index_pair[1])
    end
  end

end

#should be placed horizontally or vertically
#should be the right size
#should not be outbound
#should not touch another boat
#should be pair of letter and number
