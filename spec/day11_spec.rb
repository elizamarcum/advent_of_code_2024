require_relative 'spec_helper'

# http://adventofcode.com/2024/day/11

describe Day11 do
  describe "part1" do
    it "overall scenario" do
      expected = 55312
      actual = Day11.part1('125 17')
      _(actual).must_equal(expected)
    end
  end

  describe Day11::PhysicsDefyingStones do
    describe ".new" do
      let(:stones){ Day11::PhysicsDefyingStones.new("253000 1 7") }
      it 'creates a doubly linked list that is hooked up correctly going forward' do
        expected_forward_looking = [253000, 1, 7, nil]
        actual_forward_looking = [ stones.first.value,
                                   stones.first.next.value,
                                   stones.first.next.next.value,
                                   stones.first.next.next.next ]
        _(actual_forward_looking).must_equal(expected_forward_looking)
      end

      it 'creates a doubly linked list that is hooked up correctly going backword' do
        expected_backward_looking = [7, 1, 253000, nil]
        actual_backward_looking = [ stones.last.value,
                                    stones.last.previous.value,
                                    stones.last.previous.previous.value,
                                    stones.last.previous.previous.previous ]
        _(actual_backward_looking).must_equal(expected_backward_looking)
      end
    end

    describe "#blink!" do
      let(:state0){ Day11::PhysicsDefyingStones.new("125 17") }
      let(:state1){ Day11::PhysicsDefyingStones.new("253000 1 7") }
      let(:state2){ Day11::PhysicsDefyingStones.new("253 0 2024 14168") }
      let(:state3){ Day11::PhysicsDefyingStones.new("512072 1 20 24 28676032") }
      let(:state4){ Day11::PhysicsDefyingStones.new("512 72 2024 2 0 2 4 2867 6032") }
      let(:state5){ Day11::PhysicsDefyingStones.new("1036288 7 2 20 24 4048 1 4048 8096 28 67 60 32") }
      let(:state6){ Day11::PhysicsDefyingStones.new("2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2") }

      it 'transitions from state 0 to state 1' do
        state0.blink!
        _(state0).must_equal(state1)
      end

      it 'transitions from state 1 to state 2' do
        state1.blink!
        _(state1).must_equal(state2)
      end

      it 'transitions from state 2 to state 3' do
        state2.blink!
        _(state2).must_equal(state3)
      end

      it 'transitions from state 3 to state 4' do
        state3.blink!
        _(state3).must_equal(state4)
      end

      it 'transitions from state 4 to state 5' do
        state4.blink!
        _(state4).must_equal(state5)
      end

      it 'transitions from state 5 to state 6' do
        state5.blink!
        _(state5).must_equal(state6)
      end

      it 'transitions from initial state all the way through' do
        stones = Day11::PhysicsDefyingStones.new("125 17")
        6.times { stones.blink! }
        _(stones).must_equal(state6)
        _(stones.last.value).must_equal(2)
      end
    end

    describe "#count" do
      it 'returns the number of items in the list' do
        stones = Day11::PhysicsDefyingStones.new("2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2")
        expected = 22
        _(stones.count).must_equal(expected)
      end
    end

    describe "#equality" do
      it 'considers two different lists with the same input to be equal' do
        input = "512072 1 20 24 28676032"
        a = Day11::PhysicsDefyingStones.new(input)
        b = Day11::PhysicsDefyingStones.new(input)
        _(a).must_equal(b)
      end

      it 'considers two lists with the different input to be equal' do
        input = "512072 1 20 24 28676032"
        a = Day11::PhysicsDefyingStones.new(input)
        b = Day11::PhysicsDefyingStones.new(input.reverse)
        _(a).wont_equal(b)
      end
    end

    describe "#to_s" do
      it 'outputs the list in the same format as the input' do
        input = "512072 1 20 24 28676032"
        stones = Day11::PhysicsDefyingStones.new(input)
        _(stones.to_s).must_equal(input)
      end
    end
  end

  describe Day11::PhysicsDefyingStones::PhysicsDefyingStone do
    describe "insert" do
      let(:stones){ Day11::PhysicsDefyingStones.new("125 17") }

      describe "inserting into the middle of the list" do
        before do
          stones.first.insert Day11::PhysicsDefyingStones::PhysicsDefyingStone.new(stones, 10)
        end

        it "creates the appropriate forward links" do
          expected_forward_looking = [125, 10, 17, nil]
          actual_forward_looking = [ stones.first.value,
                                     stones.first.next.value,
                                     stones.first.next.next.value,
                                     stones.first.next.next.next ]
          _(actual_forward_looking).must_equal(expected_forward_looking)
        end

        it "creates the appropriate backwards links" do
          expected_backward_looking = [17, 10, 125, nil]
          actual_backward_looking = [ stones.last.value,
                                      stones.last.previous.value,
                                      stones.last.previous.previous.value,
                                      stones.last.previous.previous.previous ]
          _(actual_backward_looking).must_equal(expected_backward_looking)
        end
      end

      describe "adding to the end of the list" do

      end
    end
  end
end
