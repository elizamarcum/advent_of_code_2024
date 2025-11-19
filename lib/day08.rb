require_relative 'general_map'

class Day8
  def self.part1(input)
    map = Day8::Map.new(input)
    map.antinode_locations.count
  end

  def self.part2(input)
    map = Day8::Map.new(input, infinite_antinodes: true)
    map.antinode_locations.count
  end

  class Map < GeneralMap
    NON_ANTENNA = '.'
    attr_reader :antenna_types

    def initialize(input, infinite_antinodes: false)
      grid = (input.is_a? Array)? input : input.split(/\n/).map{ |line| line.split(//) }
      super(grid)
      @antenna_types = (grid.flatten.uniq - [NON_ANTENNA])
      @infinite_antinodes = infinite_antinodes
    end

    def antinode_locations
      locations = Hash.new{|hash, key| hash[key] = []} # coords: [antinode_type, antinode_type]
      antenna_types.each do |antenna_type|
        antinodes_for_antenna_type(antenna_type).each do |coords|
          locations[coords] << antenna_type
        end
      end
      locations.keys.sort
    end

    def antinodes_for_antenna_type(antenna_type)
      locations = find_all(antenna_type)
      results = []
      locations.combination(2){ |a, b| results.concat antinodes_for_coords(a, b) }
      results.sort
    end

    def antinodes_for_coords(coords_a, coords_b)
      a_x, a_y = coords_a
      b_x, b_y = coords_b
      x_diff = (a_x - b_x)
      y_diff = (a_y - b_y)

      iterate_positive = ->(x, y){ [x + x_diff, y + y_diff] }
      iterate_negative = ->(x, y){ [x - x_diff, y - y_diff] }

      if @infinite_antinodes
        antinodes = [coords_a, coords_b]
        [[iterate_positive, coords_a],
         [iterate_negative, coords_b]].each do |iterator, starting_coords|
          next_position = iterator.call(*starting_coords)
          while valid_coordinate?(*next_position)
            antinodes << next_position
            break unless @infinite_antinodes
            next_position = iterator.call(*next_position)
          end
        end
        antinodes
      else
        [
          iterate_positive.call(a_x, a_y),
          iterate_negative.call(b_x, b_y)
        ].filter{|coords| valid_coordinate?(*coords) }
      end
    end
  end
end
