class Grid

  ROW_LABEL = %w(A B C D E)
  COLUMN_LABEL = %w(1 2 3 4 5)

  def initialize
    @matrix = Array.new(5, ".").map{|row| Array.new(5, ".")}
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
    find_indexes(ship.location).each do |index|
      @matrix[index[0]][index[1]] = "X"
    end
  end

  def find_indexes(coordinates)
    indexes = []
    coordinates.each do |coordinate|
      index_row = ROW_LABEL.find_index(coordinate.chars[0])
      index_column = coordinate.chars[1].to_i - 1
    indexes << [index_row, index_column]
    end
    indexes
  end


  def free?(index_row, index_column)
    @matrix[index_row][index_column] != "X"
  end

  def inbound?(index_row, index_column)
    (0..5).include?(index_row) && (0..5).include?(index_column)
  end
end
