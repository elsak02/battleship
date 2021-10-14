class Grid
  attr_reader :matrix, :fleet, :player_name, :message
  attr_writer :fleet

  ROW_LABEL = %w(A B C D E)
  COLUMN_LABEL = %w(1 2 3 4 5)

  def initialize(player_name=nil)
    @player_name = player_name
    @matrix = Array.new(5, ".").map{|row| Array.new(5, ".")}
    @fleet = []
    @message = ""
  end

  def print_board
    print "\t"
    print COLUMN_LABEL.join("\t")
    puts
    @matrix.each_with_index do |row, i|
      print ROW_LABEL[i]
      print "\t"
      print row.join("\t")
      puts
    end
  end

  def place_ship(ship)
    Grid.find_indexes(ship.location).each do |index|
      @matrix[index[0]][index[1]] = "X"
    end
    @fleet << ship
  end

  def self.find_indexes(coordinates)
      indexes = []
      coordinates.each do |coordinate|
        index_row = ROW_LABEL.find_index(coordinate.chars[0])
        index_column = coordinate.chars[1].to_i - 1
      indexes << [index_row, index_column]
      end
      indexes
  end

  def mark_shoot!(coordinates)
    indexes = Grid.find_indexes(coordinates).first
    if free?(indexes)
      @message = "It's a MISS"
    else
      ship = @fleet.find {|ship| ship.location.include?(coordinates.first)}
      ship.remaining_shot -=1
      @matrix[indexes[0]][indexes[1]]="."
      if ship.remaining_shot == 0
        @fleet.delete(ship)
        @message = "It is a SUNK (Ship with size #{ship.size})!"
      else
        @message = "It's a HIT!"
      end
    end
  end


  def free?(indexes)
    @matrix[indexes[0]][indexes[1]] == "."
  end

  def self.inbound?(indexes)
    (0..4).include?(indexes[0]) && (0..4).include?(indexes[1])
  end
end

