require_relative 'spec_helper'

# http://adventofcode.com/2024/day/2

describe Day2 do
  let(:input) {
    <<~STRING
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 2
      actual = Day2.part1(input)
      _(actual).must_equal(expected)
    end
  end

  describe "report_safe?" do
    it "is safe if levels are all increasing by 1, 2, or 3" do
      input = %w(7 6 4 2 1).map(&:to_i)
      assert Day2.report_safe?(input)
    end

    it "is unsafe if the increase is 4" do
      input = %w(1 2 6 7 9).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if the increase is 5" do
      input = %w(1 2 7 8 9).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if the decrease is 4" do
      input = %w(9 7 6 2 1).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if the decrease is 5" do
      input = %w(9 8 7 2 1).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if levels increase then decrease" do
      input = %w(1 3 2 4 5).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if levels decrease then increase" do
      input = %w(5 4 1 2 3).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is unsafe if levels do not change" do
      input = %w(8 6 4 4 1).map(&:to_i)
      refute Day2.report_safe?(input)
    end

    it "is safe if levels are all decreasing by 1, 2, or 3" do
      input = %w(1 3 6 7 9).map(&:to_i)
      assert Day2.report_safe?(input)
    end
  end

  describe "part2" do
    it "overall scenario" do
    end
  end
end
