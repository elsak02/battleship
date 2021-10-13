require_relative "./grid.rb"
require_relative "./ship.rb"

class Game
  attr_reader :grid_player_1, :grid_player_2

  def initialize
    @grid_player_1 = Grid.new("Player One")
    @grid_player_2 = Grid.new("Player Two")
  end

  def run
    welcome!
    set_up!(@grid_player_1, 3)
    set_up!(@grid_player_1, 4)
    set_up!(@grid_player_2, 3)
    set_up!(@grid_player_2, 4)
    puts "Congratulations! The game is set up now!"
    loop do
      play!(@grid_player_1, @grid_player_2)
      play!(@grid_player_2, @grid_player_1)
      break if end_of_game?(@grid_player_2, @grid_player_1)
    end
    puts "Game is over!"
    puts "#{find_winner(@grid_player_1, @grid_player_2)} is the winner. Congratulations!"
  end

  def welcome!
    puts "Welcome to the battleship game !"
    puts
    puts "You have two ships to place on the board game."
    puts "The small one is three units long and the largest one is four units long."
    puts
  end

  def set_up!(grid, size)
    puts "#{grid.player_name} board"
    puts
    grid.print_board
    coordinates = []
    loop do
     coordinates = ask_for_coordinates(size)
     input_validated?(grid, coordinates, size) ? break : error_message(grid, coordinates, size)
    end
     ship = Ship.new(size, coordinates)
     grid.place_ship(ship)
     grid.print_board
     sleep 2
     system 'clear'
  end

  def play!(grid_player, grid_opponent)
    puts "It is your turn #{grid_player.player_name}"
    grid = Grid.new
    grid.print_board
    puts "You can try to shoot one of your opponent's ship."
    loop do
       @coordinates = ask_for_coordinates(1)
        break if shoot_coordinates_validated?(@coordinates)
    end
    grid_opponent.mark_shoot!(@coordinates)
    puts grid_opponent.message
    sleep 2
    system 'clear'
  end

  def ask_for_coordinates(size)
    example = ""
    size.times { |i| example = example + " A#{i + 1}" }
    puts "Please enter the coordinates of the ship (#{size} unit(s) long). Write the #{size} coordinate(s) as in this example:#{example}."
    gets.chomp.split
  end

  def input_validated?(grid, coordinates, size)
    return false unless right_size?(coordinates, size) && right_direction?(coordinates, size)

    Grid.find_indexes(coordinates).each do |indexes|
      return false unless grid.free?(indexes) && Grid.inbound?(indexes)
    end

    true
  end

  def right_size?(coordinates, size)
    coordinates.length == size && any_consecutive?(coordinates)
  end

  def right_direction?(coordinates, size)
    array = coordinates.join.chars
    if size == 3
      [array[0], array[2], array[4]].uniq.count == 1 || [array[1], array[3], array[5]].uniq.count == 1
    else
      [array[0], array[2], array[4], array[6]].uniq.count == 1 || [array[1], array[3], array[5], array[7]].uniq.count == 1
    end
  end

  def any_consecutive?(coordinates)
    array = coordinates.join.chars

    array_letters = array.select{ |element| Grid::ROW_LABEL.include?(element) }.map{ |letter| Grid::ROW_LABEL.find_index(letter)}.sort
    array_numbers = array.select{ |element| Grid::COLUMN_LABEL.include?(element) }.map(&:to_i).sort

    array_validations = []
    array_validations << true if array_letters.each_cons(2).all? {|a, b| b == a + 1 }
    array_validations << true if array_numbers.each_cons(2).all? {|a, b| b == a + 1 }

    array_validations.include?(true)
  end

  def error_message(grid, coordinates, size)
    puts "The ship should be of the right size" unless right_size?(coordinates, size)
    puts "The ship should be placed horizontally or vertically" unless right_direction?(coordinates, size)
    Grid.find_indexes(coordinates).each do |indexes|
      return puts "The ship should be placed within the grid bounds" unless Grid.inbound?(indexes)
      return puts "There is already a ship in #{Grid::ROW_LABEL[indexes[0]]}#{indexes[1] + 1}" unless grid.free?(indexes)
    end
  end

  def shoot_coordinates_validated?(coordinates)
    indexes = Grid.find_indexes(coordinates)
    coordinates.length == 1 && Grid.inbound?(indexes)
  end

  def end_of_game?(grid_one, grid_two)
    grid_one.fleet.empty? || grid_two.fleet.empty?
  end

  def find_winner(grid_one, grid_two)
    grid_layer_one.fleet.empty? ? grid_player_one.player_name : grid_player_two.player_name
  end
end

#should be placed horizontally or vertically
#should be the right size
#should not be outbound
#should not touch another boat
#should be pair of letter and number
