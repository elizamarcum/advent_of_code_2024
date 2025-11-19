require_relative 'spec_helper'

# http://adventofcode.com/2024/day/9

describe Day9 do
  let(:overall_scenario_input) { '2333133121414131402' }

  describe "part1" do
    it "overall scenario" do
      expected = 1928
      actual = Day9.part1(overall_scenario_input)
      _(actual).must_equal(expected)
    end
  end

  describe "part2" do
    it "overall scenario" do
      skip
      expected = 2858
      actual = Day9.part2(overall_scenario_input)
      _(actual).must_equal(expected)
    end
  end

  describe Day9::FileSystem do
    describe "#new with diskmap" do
      it 'parses the diskmap into file block positions' do
        actual = Day9::BlockFileSystem.new(nil, diskmap: '2333133121414131402').to_s
        expected = '00...111...2...333.44.5555.6666.777.888899'
        _(actual).must_equal(expected)
      end
    end

    describe "#new from string" do
      it 'results in a BlockFileSystem that outputs the same as its to_s with a small example' do
        expected = '00...111'
        actual = Day9::BlockFileSystem.new(expected).to_s
        _(actual).must_equal(expected)
      end

      it 'results in a BlockFileSystem that outputs the same as its to_s with a longer example' do
        expected = '00...111...2...333.44.5555.6666.777.888899'
        actual = Day9::BlockFileSystem.new(expected).to_s
        _(actual).must_equal(expected)
      end

      it 'can handle a file that is split across multiple areas' do
        expected = '9900...111...2...333.44.5555.6666.777.888899'
        actual = Day9::BlockFileSystem.new(expected).to_s
        _(actual).must_equal(expected)
      end
    end

    describe "#all_free_space_contiguous?" do
      it 'returns true when there is no free space' do
        assert Day9::BlockFileSystem.new('001122').all_free_space_contiguous?
      end
      it 'returns true when there is no gap in the free space' do
        assert Day9::BlockFileSystem.new('022111222......').all_free_space_contiguous?
      end
      it 'returns false when there are gaps in the free space' do
        refute Day9::BlockFileSystem.new('02211122..2....').all_free_space_contiguous?
      end
      it 'returns false if the freespace is all at the beginning' do
        refute Day9::BlockFileSystem.new('...02211122').all_free_space_contiguous?
      end
    end

    describe "#checksum" do
      it 'sums the values of block position x fileID' do
        filesystem = Day9::BlockFileSystem.new('0099811188827773336446555566..............')
        expected = 1928
        _(filesystem.checksum).must_equal(expected)
      end
    end

    describe "#to_s" do
      it 'outputs a string representation of the file block positions' do
        actual = Day9::BlockFileSystem.new('00...111...2...333.44.5555.6666.777.888899')
        expected = '00...111...2...333.44.5555.6666.777.888899'
        _(actual.to_s).must_equal(expected)
      end
    end
  end

  describe Day9::BlockFileSystem do
    let(:input){ '0..111....22222' }
    let(:expected_output_1){ '02.111....2222.' }
    let(:expected_output_2){ '022111....222..' }
    let(:expected_output_3){ '0221112...22...' }
    let(:expected_output_4){ '02211122..2....' }
    let(:expected_output_5){ '022111222......' }

    describe "#compact! moves file blocks one at a time from the end of the disk to the leftmost free space block until all free space is contiguous" do
      describe 'without limits' do
        it 'fully compacts the short example' do
          fs = Day9::BlockFileSystem.new(input)
          fs.compact!
          _(fs.to_s).must_equal expected_output_5
        end

        it 'fully compacts the long example' do
          fs = Day9::BlockFileSystem.new(nil, diskmap: overall_scenario_input)
          expected = '0099811188827773336446555566..............'
          fs.compact!
          _(fs.to_s).must_equal expected
        end
      end

      describe "with limit 1 takes only one increment" do
        it 'moves from initial input to state 1' do
          fs = Day9::BlockFileSystem.new(input)
          fs.compact!(limit: 1)
          _(fs.to_s).must_equal expected_output_1
        end

        it 'moves from state 1 to state 2' do
          fs = Day9::BlockFileSystem.new(expected_output_1)
          fs.compact!(limit: 1)
          _(fs.to_s).must_equal expected_output_2
        end

        it 'moves from state 2 to state 3' do
          fs = Day9::BlockFileSystem.new(expected_output_2)
          fs.compact!(limit: 1)
          _(fs.to_s).must_equal expected_output_3
        end

        it 'moves from state 3 to state 4' do
          fs = Day9::BlockFileSystem.new(expected_output_3)
          fs.compact!(limit: 1)
          _(fs.to_s).must_equal expected_output_4
        end

        it 'moves from state 4 to state 5' do
          fs = Day9::BlockFileSystem.new(expected_output_4)
          fs.compact!(limit: 1)
          _(fs.to_s).must_equal expected_output_5
        end
      end
    end
  end
end
