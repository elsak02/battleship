require_relative "spec_helper"
require "game"

RSpec.describe Game do
  before do
    @game= Game.new
  end
  context "Set up of the game" do
    it "#right_size? it does not allow a ship to be placed if it is not the right size" do
      expect(@game.right_size?(["A1", "A2", "A4"], 3)).to be false
      expect(@game.right_size?(["A1", "A2", "A4"], 4)).to be false
      expect(@game.right_size?(["A2", "A3", "A4"], 3)).to be true
    end

    it "#right_direction? it does not allow a ship to be placed if not horizontally or vertically" do
      expect(@game.right_direction?(["A1", "B2", "C3"], 3)).to be false
      expect(@game.right_direction?(["E1", "D2", "B3"], 3)).to be false
      expect(@game.right_direction?(["A1", "A2", "A3", "A4"], 4)).to be true
      expect(@game.right_direction?(["B5", "C5", "D5"], 3)).to be true
    end

    it "#inbound? it checks if a ship is in the grid" do
      expect(Grid.inbound?([0,1])).to be true
      expect(Grid.inbound?([5,6])).to be false
    end

    it "#free? it checks if a space is free before placing a ship" do
      @game.grid_player_1.matrix[1][2] = "X"
      expect(@game.grid_player_1.free?([1,2])).to be false
      expect(@game.grid_player_1.free?([0,1])).to be true
    end
  end
  context "Game play" do
    it "#mark_shoot? it sends a message for each shot specifying if it is a Hit, Miss or Sunk" do
      ship = Ship.new(3, ["A1", "A2", "A3"])
      @game.grid_player_1.place_ship(ship)

      expect(@game.grid_player_1.mark_shoot!(["B1"])).to eq("It's a MISS")
      expect(@game.grid_player_1.mark_shoot!(["A1"])).to eq("It's a HIT!")
      expect(@game.grid_player_1.mark_shoot!(["A2"])).to eq("It's a HIT!")
      expect(@game.grid_player_1.mark_shoot!(["A3"])).to eq("It is a SUNK (Ship with size #{ship.size})!")
    end

    it "#end_of_game? it ends when all the ships of a player are sunk!" do
      ship = Ship.new(3, ["A1", "A2", "A3"])
      @game.grid_player_1.fleet = []
      @game.grid_player_2.fleet = [ship]

      expect(@game.end_of_game?(@game.grid_player_1, @game.grid_player_2)).to be true
    end
  end
end
