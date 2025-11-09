require_relative 'spec_helper'

# http://adventofcode.com/2024/day/5

describe Day5 do
  let(:input) {
    <<~STRING
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 143
      actual = Day5.part1(input)
      _(actual).must_equal(expected)
    end
  end

  describe Day5::PageOrderingRules do
    let(:sample_rule_list) do
      [
        [47, 53],
        [97, 13],
        [97, 61],
        [97, 47],
        [75, 29],
        [61, 13],
        [75, 53],
        [29, 13],
        [97, 29],
        [53, 29],
        [61, 53],
        [97, 53],
        [61, 29],
        [47, 13],
        [75, 47],
        [97, 75],
        [47, 61],
        [75, 61],
        [47, 29],
        [75, 13],
        [53, 13],
      ]
    end

    describe "repair!" do
      it "repairs example 1" do
        input = [75,97,47,61,53]
        expected_output = [97,75,47,61,53]
        Day5::PageOrderingRules.new(sample_rule_list).repair!(input)
        _(input).must_equal expected_output
      end

      it "repairs example 2" do
        input = [61,13,29]
        expected_output = [61,29,13]
        Day5::PageOrderingRules.new(sample_rule_list).repair!(input)
        _(input).must_equal expected_output
      end

      it "repairs example 3" do
        input = [97,13,75,29,47]
        expected_output = [97,75,47,29,13]
        Day5::PageOrderingRules.new(sample_rule_list).repair!(input)
        _(input).must_equal expected_output
      end
    end

    describe "invalidates?" do
      it "is false for example one" do
        refute Day5::PageOrderingRules.new(sample_rule_list).invalidates?([75,47,61,53,29])
      end
      it "is false for example two" do
        refute Day5::PageOrderingRules.new(sample_rule_list).invalidates?([97,61,53,29,13])
      end
      it "is false for example three" do
        refute Day5::PageOrderingRules.new(sample_rule_list).invalidates?([75,29,13])
      end
      it "is true for example four" do
        assert Day5::PageOrderingRules.new(sample_rule_list).invalidates?([75,97,47,61,53])
      end
      it "is true for example five" do
        assert Day5::PageOrderingRules.new(sample_rule_list).invalidates?([61,13,29])
      end
      it "is true for example six" do
        assert Day5::PageOrderingRules.new(sample_rule_list).invalidates?([97,13,75,29,47])
      end
    end
  end

  describe "part2" do
    it "overall scenario" do
      expected = 123
      actual = Day5.part2(input)
      _(actual).must_equal(expected)
    end
  end
end
