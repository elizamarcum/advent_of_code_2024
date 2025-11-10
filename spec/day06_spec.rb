require_relative 'spec_helper'

# http://adventofcode.com/2024/day/6

describe Day6 do
  let(:grid_state_one) {
    <<~STRING
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    STRING
  }
  let(:grid_state_two) {
    <<~STRING
      ....#.....
      ....^....#
      ..........
      ..#.......
      .......#..
      ..........
      .#........
      ........#.
      #.........
      ......#...
    STRING
  }
  let(:grid_state_three) {
    <<~STRING
      ....#.....
      ........>#
      ..........
      ..#.......
      .......#..
      ..........
      .#........
      ........#.
      #.........
      ......#...
    STRING
  }
  let(:grid_state_four) {
    <<~STRING
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#......v.
      ........#.
      #.........
      ......#...
    STRING
  }
  let(:grid_state_five) {
    <<~STRING
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#<.......
      ........#.
      #.........
      ......#...
    STRING
  }
  let(:grid_state_at_end) {
    <<~STRING
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#........
      ........#.
      #.........
      ......#v..
    STRING
  }
  let(:grid_state_final) {
    <<~STRING
      ....#.....
      ....XXXXX#
      ....X...X.
      ..#.X...X.
      ..XXXXX#X.
      ..X.X.X.X.
      .#XXXXXXX.
      .XXXXXXX#.
      #XXXXXXX..
      ......#X..
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 41
      actual = Day6.part1(grid_state_one)
      _(actual).must_equal(expected)
    end
  end

  describe Day6::Guard do
    describe "on_grid?" do
      it "is true when the guard is on the map" do
        guard = Day6::Guard.new(grid_state_at_end)
        assert guard.on_grid?
        guard.travel!
        refute guard.on_grid?
      end
    end

    describe "travel!" do
      it "travels in same direction until an obstacle is reached" do
        expected = Day6::Guard.new(grid_state_two).current_map
        guard = Day6::Guard.new(grid_state_one)
        guard.travel!
        actual = guard.current_map
        _(actual).must_equal(expected)
      end

      it "goes East when there is an obstacle to the North" do
        expected = Day6::Guard.new(grid_state_three).current_map
        guard = Day6::Guard.new(grid_state_two)
        guard.travel!
        actual = guard.current_map
        _(actual).must_equal(expected)
      end
      it "goes South when there is an obstacle to the East" do
        expected = Day6::Guard.new(grid_state_four).current_map
        guard = Day6::Guard.new(grid_state_three)
        guard.travel!
        actual = guard.current_map
        _(actual).must_equal(expected)
      end
      it "goes West when there is an obstacle to the South" do
        expected = Day6::Guard.new(grid_state_five).current_map
        guard = Day6::Guard.new(grid_state_four)
        guard.travel!
        actual = guard.current_map
        _(actual).must_equal(expected)
      end
      it "eventually reaches the edge of the map" do
        expected = Day6::Guard.new(grid_state_final).current_map(with_path: true)
        guard = Day6::Guard.new(grid_state_one)
        while guard.on_grid?
          guard.travel!
        end
        actual = guard.current_map(with_path: true)
        _(actual).must_equal(expected)
      end
    end
  end

  describe "part2" do
    it "overall scenario" do
      expected = "TBD"
      actual = Day6.part2(grid_state_one)
      _(actual).must_equal(expected)
    end
  end
end
