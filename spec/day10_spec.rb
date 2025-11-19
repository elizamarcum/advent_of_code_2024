require_relative 'spec_helper'

# http://adventofcode.com/2024/day/10

describe Day10 do
  let(:large_sample) {
    <<~STRING
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 36
      actual = Day10.part1(large_sample)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "overall scenario" do
      expected = "TBD"
      actual = Day10.part2(large_sample)
      _(actual).must_equal(expected)
    end
  end

  describe Day10::Map do

  end

  describe Day10::Trailheads do
    describe ".for" do
      it 'returns a trailhead for each 0 on the map' do
        map = Day10::Map.new(large_sample)
        trailheads = Day10::Trailheads.for(map)
        _(trailheads.count).must_equal(9)
        _(trailheads[0].coords).must_equal([0, 2])
      end
    end

    describe "trailbutts" do
      it 'returns every valid trailbutt from the trailhead for example 1' do
        input =
          <<~STRING
            0123
            1234
            8765
            9876
          STRING
        expected = [[3, 0]]
        map = Day10::Map.new(input)
        actual = Day10::Trailheads.new(map, 0, 0).trailbutts
        _(actual).must_equal(expected)
      end

      it 'returns every valid trailbutt from the trailhead for example 2' do
        input =
          <<~STRING
            ...0...
            ...1...
            ...2...
            6543456
            7.....7
            8.....8
            9.....9
          STRING
        expected = [[6, 6], [6, 0]]
        map = Day10::Map.new(input)
        actual = Day10::Trailheads.new(map, 0, 3).trailbutts
        _(actual).must_equal(expected)
      end

      it 'returns every valid trail from the trailbutt for example 3' do
        input =
          <<~STRING
            ..90..9
            ...1.98
            ...2..7
            6543456
            765.987
            876....
            987....
          STRING
        expected = [[4, 4], [0, 6], [1, 5], [6, 0]]
        map = Day10::Map.new(input)
        actual = Day10::Trailheads.new(map, 0, 3).trailbutts
        _(actual).must_equal(expected)
      end

      it 'returns every valid trail from the trailbutt for both trailheads in example 4' do
        input =
          <<~STRING
            10..9..
            2...8..
            3...7..
            4567654
            ...8..3
            ...9..2
            .....01
          STRING
        map = Day10::Map.new(input)

        expected = [[5, 3]]
        actual = Day10::Trailheads.new(map, 0, 1).trailbutts
        _(actual).must_equal(expected)

        expected = [[0, 4], [5, 3]]
        actual = Day10::Trailheads.new(map, 6, 5).trailbutts
        _(actual).must_equal(expected)
      end

      it 'returns something appropriate for the troublesome trailhead from the largest example' do
        map = Day10::Map.new(large_sample)
        expected = [[5, 4], [4, 5], [3, 4], [0, 1], [3, 0]]
        actual = Day10::Trailheads.new(map, 6, 0).trailbutts
        _(actual).must_equal(expected)
      end
    end

    describe 'score' do
      it 'returns every valid trailbutt count for the largest examples' do
        map = Day10::Map.new(large_sample)
        actual = Day10::Trailheads.for(map).map(&:score)
        expected = [5, 6, 5, 3, 1, 3, 5, 3, 5]
        _(actual).must_equal(expected)
      end
    end
  end
end
