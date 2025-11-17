require_relative 'spec_helper'

describe GeneralMap do
  let(:map) do
    GeneralMap.new( [ %w(x x x x),
                      %w(x x x x),
                      %w(x x x x) ] )
  end
  describe 'valid_coordinate?' do
    it 'is false for negative x' do
      refute map.valid_coordinate?(-1, 0)
    end

    it 'is false for negative y' do
      refute map.valid_coordinate?(0, -1)
    end

    it 'is false for x value just outside the map' do
      refute map.valid_coordinate?(3, 3)
    end

    it 'is false for y value just outside the map' do
      refute map.valid_coordinate?(3, 3)
    end

    it 'is true for coords just inside the map' do
      assert map.valid_coordinate?(3, 2)
    end
  end

  describe 'find_all' do
    let(:map) do
      GeneralMap.new( [ %w(a b b a),
                        %w(b c d e),
                        %w(c f g a) ] )
    end
    it 'accepts a block' do
      expected = [
        [0, 0],
        [0, 3],
        [2, 2],
        [2, 3] ]
      actual = map.find_all{ |item| item == 'a' or item == 'g' }
      _(actual).must_equal expected
    end
    it 'returns an empty array if the value cannot be found' do
      actual = map.find_all('j')
      _(actual).must_be :empty?
    end
    it 'returns an array of all locations where the value is found' do
      actual = map.find_all('a')
      expected = [ [0, 0], [0, 3], [2, 3] ]
      _(actual).must_equal expected
    end
  end
end
