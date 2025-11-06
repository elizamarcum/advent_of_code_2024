require_relative 'spec_helper'

# http://adventofcode.com/2017/day/1

describe Day1 do
  describe "part1" do
    it "scenario 1" do
      input = "1122"
      expected = 3
      actual = Day1.part1(input)
      _(actual).must_equal(expected)
    end
    it "scenario 2" do
      input = "1111"
      expected = 4
      actual = Day1.part1(input)
      _(actual).must_equal(expected)
    end
    it "scenario 3" do
      input = "1234"
      expected = 0
      actual = Day1.part1(input)
      _(actual).must_equal(expected)
    end
    it "scenario 4" do
      input = "91212129"
      expected = 9
      actual = Day1.part1(input)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "scenario 1" do
      input = "1212"
      expected = 6
      actual = Day1.part2(input)
      _(actual).must_equal(expected)
    end
    it "scenario 2" do
      input = "1221"
      expected = 0
      actual = Day1.part2(input)
      _(actual).must_equal(expected)
    end
    it "scenario 3" do
      input = "123425"
      expected = 4
      actual = Day1.part2(input)
      _(actual).must_equal(expected)
    end
    it "scenario 4" do
      input = "123123"
      expected = 12
      actual = Day1.part2(input)
      _(actual).must_equal(expected)
    end
    it "scenario 5" do
      input = "12131415"
      expected = 4
      actual = Day1.part2(input)
      _(actual).must_equal(expected)
    end
  end
end
