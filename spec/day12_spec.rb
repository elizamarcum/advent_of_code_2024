require_relative 'spec_helper'

# http://adventofcode.com/2024/day/12

describe Day12 do
  let(:example_1) {
    <<~STRING
      AAAA
      BBCD
      BBCC
      EEEC
    STRING
  }

  let(:example_2) {
    <<~STRING
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
    STRING
  }

  let(:example_3) {
    <<~STRING
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
    STRING
  }

  let(:example_4) {
    <<~STRING
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
    STRING
  }

  let(:example_5) {
    <<~STRING
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 1930
      actual = Day12.part1(example_3)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "overall scenario" do
      expected = 1206
      actual = Day12.part2(example_3)
      _(actual).must_equal(expected)
    end
  end

  describe Day12::Garden do
    describe "plots" do
      it 'creates the correct plots for example 1' do
        actual = Day12::Garden.new(example_1).plots
        expected = %w(A B C D E)
        _(actual.map(&:designator)).must_equal(expected)
      end

      it 'creates the correct plots for example 2' do
        actual = Day12::Garden.new(example_2).plots
        expected = %w(O X X X X)
        _(actual.map(&:designator)).must_equal(expected)
      end

      it 'creates the correct plots for example 3' do
        actual = Day12::Garden.new(example_3).plots
        expected = %w(R I C F V J C E I M S)
        _(actual.map(&:designator)).must_equal(expected)
      end
    end

    describe "total_discounted_fencing_cost" do
      it 'calculates example 1' do
        actual = Day12::Garden.new(example_1).total_discounted_fencing_cost
        expected = 80
        _(actual).must_equal(expected)
      end

      it 'calculates example 4' do
        actual = Day12::Garden.new(example_4).total_discounted_fencing_cost
        expected = 236
        _(actual).must_equal(expected)
      end

      it 'calculates example 5' do
        actual = Day12::Garden.new(example_5).total_discounted_fencing_cost
        expected = 368
        _(actual).must_equal(expected)
      end
    end

    describe "total_fencing_cost" do
      it 'calculates example 1' do
        actual = Day12::Garden.new(example_1).total_fencing_cost
        expected = 140
        _(actual).must_equal(expected)
      end

      it 'calculates example 2' do
        actual = Day12::Garden.new(example_2).total_fencing_cost
        expected = 772
        _(actual).must_equal(expected)
      end

      it 'calculates example 3' do
        actual = Day12::Garden.new(example_3).total_fencing_cost
        expected = 1930
        _(actual).must_equal(expected)
      end
    end
  end

  describe Day12::GardenPlot do
    describe '#area' do
      it 'calculates the area for a square plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'B'}
        expected = 4
        _(plot.area).must_equal(expected)
      end

      it 'calculates the area for a plot with holes in' do
        plot = Day12::Garden.new(example_2).plots.find{|plot| plot.designator == 'O'}
        expected = 21
        _(plot.area).must_equal(expected)
      end

      it 'calculates the area for a plot with a non-unique designator' do
        plot = Day12::Garden.new(example_2).plots.find{|plot| plot.designator == 'X'}
        expected = 1
        _(plot.area).must_equal(expected)
      end

      it 'it calculates the area for a squiggly plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'C'}
        expected = 4
        _(plot.area).must_equal(expected)
      end
    end

    describe '#perimeter' do
      it 'calculates the perimeter for a square plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'B'}
        expected = 8
        _(plot.perimeter).must_equal(expected)
      end

      it 'calculates the perimeter for a plot with holes in' do
        plot = Day12::Garden.new(example_2).plots.find{|plot| plot.designator == 'O'}
        expected = 36
        _(plot.perimeter).must_equal(expected)
      end

      it 'calculates the perimeter for a plot with a non-unique designator' do
        plot = Day12::Garden.new(example_2).plots.find{|plot| plot.designator == 'X'}
        expected = 4
        _(plot.perimeter).must_equal(expected)
      end

      it 'it calculates the perimeter for a squiggly plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'C'}
        expected = 10
        _(plot.perimeter).must_equal(expected)
      end
    end

    describe '#sides' do
      it 'calculates the sides for the simplest quadrilateral plots' do
        small_input =
          <<~STRING
            AABB
            AACC
            DDDD
            DDDD
          STRING
        plot = Day12::Garden.new(small_input).plots.find{|plot| plot.designator == 'A'}
        expected = 4
        _(plot.sides).must_equal(expected)
      end

      it 'calculates the sides for a square plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'B'}
        expected = 4
        _(plot.sides).must_equal(expected)
      end

      it 'it calculates the sides for a squiggly plot' do
        plot = Day12::Garden.new(example_1).plots.find{|plot| plot.designator == 'C'}
        expected = 8
        _(plot.sides).must_equal(expected)
      end

      it 'calculates the sides for a plot with holes in' do
        plot = Day12::Garden.new(example_5).plots.find{|plot| plot.designator == 'A'}
        expected = 12
        _(plot.sides).must_equal(expected)
      end

      it 'calculates the sides for a plot with an E shape' do
        plot = Day12::Garden.new(example_4).plots.find{|plot| plot.designator == 'E'}
        expected = 12
        _(plot.sides).must_equal(expected)
      end

      it 'calculates the sides for a plot with a non-unique designator' do
        plot = Day12::Garden.new(example_4).plots.find{|plot| plot.designator == 'X'}
        expected = 4
        _(plot.sides).must_equal(expected)
      end
    end
  end
end
