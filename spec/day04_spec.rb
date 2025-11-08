require_relative 'spec_helper'

# http://adventofcode.com/2024/day/4

describe Day4 do
    let(:short_example) {
      <<~STRING
        ..X...
        .SAMX.
        .A..A.
        XMAS.S
        .X....
      STRING
    }

    let(:long_example) {
      <<~STRING
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
      STRING
    }

  describe "part1" do
    it "short example scenario" do
      expected = 4
      actual = Day4.part1(short_example)
      _(actual).must_equal(expected)
    end

    it "long example scenario" do
      expected = 18
      actual = Day4.part1(long_example)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "overall scenario" do
      input = ""
      expected = "TBD"
      actual = Day4.part2(input)
      _(actual).must_equal(expected)
    end
  end
end
