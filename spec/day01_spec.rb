require_relative 'spec_helper'

# http://adventofcode.com/2024/day/1

describe Day1 do
  describe "part1" do
    it "scenario 1" do
      input =
        <<~STRING
          3   4
          4   3
          2   5
          1   3
          3   9
          3   3
        STRING
      expected = 11
      actual = Day1.part1(input)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
  end
end
