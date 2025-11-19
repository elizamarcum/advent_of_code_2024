require_relative 'general_map'

class Day10
  def self.part1(input)
    map = Day10::Map.new(input)
    Trailheads.for(map).sum { |trailhead| trailhead.score }
  end

  def self.part2(input)
    "TBD"
  end

  class Map < GeneralMap
    attr_reader :trailheads

    def initialize(input)
      super(input)
    end
  end

  class Trailheads
    TRAILHEAD = '0'
    def initialize(map, x, y)
      @x, @y = x, y
      @map = map
    end

    def coords
      [@x, @y]
    end

    def score
      trailbutts.count
    end

    def trailbutts
      return @trailbutts if @trailbutts
      @trailbutts = []
      coords_reached = [coords]
      %w(1 2 3 4 5 6 7 8 9).each do |next_step|
        next_coords_reached = []
        coords_reached.map do |location|
          next_coords_reached += coords_of_x_reachable_by_location(next_step, location)
        end
        coords_reached = next_coords_reached.uniq
      end
      @trailbutts = coords_reached
    end

    def self.for(map)
      map.find_all(TRAILHEAD).map{ |coords| self.new(map, *coords) }
    end

    private

    def coords_of_x_reachable_by_location(next_step, location)
      x, y = location
      output = []
      variations = [
        [1, 0],
        [0, 1],
        [-1, 0],
        [0, -1]
      ]
      variations.each do |d_x, d_y|
        test_x = x + d_x
        test_y = y + d_y
        if @map.valid_coordinate?(test_x, test_y) and @map[test_x, test_y] == next_step
          output << [test_x, test_y]
        end
      end
      output
    end
  end
end
