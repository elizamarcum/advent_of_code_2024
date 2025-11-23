require_relative 'spec_helper'

# http://adventofcode.com/2024/day/13

describe Day13 do
  let(:input) {
    <<~STRING
      Button A: X+94, Y+34
      Button B: X+22, Y+67
      Prize: X=8400, Y=5400

      Button A: X+26, Y+66
      Button B: X+67, Y+21
      Prize: X=12748, Y=12176

      Button A: X+17, Y+86
      Button B: X+84, Y+37
      Prize: X=7870, Y=6450

      Button A: X+69, Y+23
      Button B: X+27, Y+71
      Prize: X=18641, Y=10279
    STRING
  }

  describe "part1" do
    it "overall scenario" do
      expected = 480
      actual = Day13.part1(input)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "overall scenario" do
      skip
      expected = "TBD"
      actual = Day13.part2(input)
      _(actual).must_equal(expected)
    end
  end

  describe Day13::ClawMachine do
    let(:machine_1_input) {
      <<~STRING
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
      STRING
    }
    let(:machine_2_input) {
      <<~STRING
        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176
      STRING
    }
    let(:machine_3_input) {
      <<~STRING
        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450
      STRING
    }
    let(:machine_4_input) {
      <<~STRING
        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
      STRING
    }
    let(:machine_1){ Day13::ClawMachine.new(machine_1_input) }
    let(:machine_2){ Day13::ClawMachine.new(machine_2_input) }
    let(:machine_3){ Day13::ClawMachine.new(machine_3_input) }
    let(:machine_4){ Day13::ClawMachine.new(machine_4_input) }
    let(:machine_1_with_input_correction){ Day13::ClawMachine.new(machine_1_input, apply_input_correction: true) }
    let(:machine_2_with_input_correction){ Day13::ClawMachine.new(machine_2_input, apply_input_correction: true) }
    let(:machine_3_with_input_correction){ Day13::ClawMachine.new(machine_3_input, apply_input_correction: true) }
    let(:machine_4_with_input_correction){ Day13::ClawMachine.new(machine_4_input, apply_input_correction: true) }

    describe "initialize" do
      it 'sets the initial values for the machine' do
        _(machine_1.a_delta_x).must_equal(94)
        _(machine_1.a_delta_y).must_equal(34)
        _(machine_1.b_delta_x).must_equal(22)
        _(machine_1.b_delta_y).must_equal(67)
        _(machine_1.goal_x).must_equal(8400)
        _(machine_1.goal_y).must_equal(5400)
      end
      describe "initialize with input correction" do
        it 'sets the initial values for the machine' do
          _(machine_1_with_input_correction.goal_x).must_equal(10000000008400)
          _(machine_1_with_input_correction.goal_y).must_equal(10000000005400)
        end
      end
    end

    describe "is_solveable?" do
      it 'is true for machine 1' do
        assert machine_1.is_solveable?
      end

      it 'is false for machine 2' do
        refute machine_2.is_solveable?
      end

      it 'is true for machine 3' do
        assert machine_3.is_solveable?
      end

      it 'is false for machine 4' do
        refute machine_4.is_solveable?
      end
    end

    describe "minimum_win_cost" do
      it 'is 280 for machine 1' do
        _(machine_1.minimum_win_cost).must_equal(280)
      end

      it 'is nil for machine 2' do
        _(machine_2.minimum_win_cost).must_be_nil
      end

      it 'is 200 for machine 3' do
        _(machine_3.minimum_win_cost).must_equal(200)
      end

      it 'is nil for machine 4' do
        _(machine_4.minimum_win_cost).must_be_nil
      end

      describe 'for a corrected machine' do
        before do
          skip
        end

        it 'is nil for machine 1' do
          _(machine_1_with_input_correction.minimum_win_cost).must_be_nil
        end

        it 'is something for machine 2' do
          _(machine_2_with_input_correction.minimum_win_cost).must_equal(100)
        end

        it 'is nil for machine 3' do
          _(machine_3_with_input_correction.minimum_win_cost).must_be_nil
        end

        it 'is something for machine 4' do
          _(machine_4_with_input_correction.minimum_win_cost).must_equal(100)
        end
      end
    end
  end
end
