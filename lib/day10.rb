require_relative 'map'

class Day10
  def self.part1(input)
    map = Map.new(input)
    Trailheads.for(map).sum { |trailhead| trailhead.trailbutts.count }
  end

  def self.part2(input)
    map = Map.new(input)
    Trailheads.for(map).sum { |trailhead| trailhead.trails.count }
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

    def trails
      return @trails if @trails
      trails_so_far = [ [coords] ]
      %w(1 2 3 4 5 6 7 8 9).each do |next_step|
        trails_that_go_the_next_mile = []
        trails_so_far.each do |trail|
          next_steps = coords_of_x_reachable_by_location(next_step, trail.last)
          next_steps.map do |new_coord|
            trails_that_go_the_next_mile << trail.dup.append(new_coord)
          end
        end
        trails_so_far = trails_that_go_the_next_mile
      end
      @trails = trails_so_far
    end

    def trailbutts
      return @trailbutts if @trailbutts
      coords_reached = [coords]
      %w(1 2 3 4 5 6 7 8 9).each do |next_step|
        next_coords_reached = []
        coords_reached.each do |location|
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
