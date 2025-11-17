require_relative 'general_map'

class Day8
  def self.part1(input)
    map = Day8::Map.new(input)
    map.antinode_locations.count
  end

  def self.part2(input)
    "TBD"
  end

  class Map < GeneralMap
    NON_ANTENNA = '.'
    attr_reader :antenna_types

    def initialize(input)
      grid = (input.is_a? Array)? input : input.split(/\n/).map{ |line| line.split(//) }
      super(grid)
      @antenna_types = (grid.flatten.uniq - [NON_ANTENNA])
    end

    def antinode_locations
      locations = Hash.new{|hash, key| hash[key] = []} # coords: [antinode_type, antinode_type]
      antenna_types.each do |antenna_type|
        antinodes_for_antenna_type(antenna_type).each do |coords|
          locations[coords] << antenna_type
        end
      end
      locations.keys
    end

    def antinodes_for_antenna_type(antenna_type)
      locations = find_all(antenna_type)
      results = []
      locations.combination(2){ |a, b| results.concat antinodes_for_coords(a, b) }
      results
    end

    def antinodes_for_coords(coords_a, coords_b)
      a_x, a_y = coords_a
      b_x, b_y = coords_b
      x_diff = (a_x - b_x)
      y_diff = (a_y - b_y)
      [
        [a_x + x_diff, a_y + y_diff],
        [b_x - x_diff, b_y - y_diff]
      ].filter{|coords| valid_coordinate? *coords }
    end
  end
end
