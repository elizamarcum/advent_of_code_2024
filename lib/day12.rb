require_relative 'map'

class Day12
  def self.part1(input)
    garden = Garden.new(input)
    garden.total_fencing_cost
  end

  def self.part2(input)
    garden = Garden.new(input)
    garden.total_discounted_fencing_cost
  end

  class Garden < Map
    attr_reader :plots

    def initialize(input)
      super(input)
      @plots = []
      each_with_index do |plot, x, y|
        next if plot.is_a? GardenPlot
        @plots << GardenPlot.new(self, plot, x, y)
      end
    end

    def total_fencing_cost
      plots.sum(&:fencing_cost)
    end

    def total_discounted_fencing_cost
      plots.sum(&:discounted_fencing_cost)
    end
  end

  class GardenPlot
    attr_reader :designator, :sides

    def initialize(garden, plot_designator, starting_x, starting_y)
      @garden = garden
      @designator = plot_designator
      @starting_x = starting_x
      @starting_y = starting_y
      mark_plots_occupied_on_map
      evaluate_perimeter
    end

    def area
      @positions_occupied.count
    end

    def perimeter
      @perimeter.count
    end

    def discounted_fencing_cost
      area * sides
    end

    def fencing_cost
      area * perimeter
    end

    def to_s
      "#{designator} #{@positions_occupied}"
    end

    private

    def evaluate_perimeter
      points = @perimeter.dup
      @sides = 0
      until points.empty?
        x, y, perimeter_lays_along_direction = points.first
        travel_until_end_of_side(points, x, y, perimeter_lays_along_direction)
        @sides += 1
      end
      @sides
    end

    def travel_until_end_of_side(points, initial_x, initial_y, perimeter_lays_along_direction)
      directions_of_travel = [perimeter_lays_along_direction.next, perimeter_lays_along_direction.previous]
      points.delete([initial_x, initial_y, perimeter_lays_along_direction])
      directions_of_travel.each do |direction_of_travel|
        x, y = direction_of_travel.of(initial_x, initial_y)
        while point = points.delete([x, y, perimeter_lays_along_direction])
          x, y = direction_of_travel.of(x, y)
        end
      end
    end

    # Replace each spot of map for which this GardenPlot applies
    # with a reference to this GardenPlot
    def mark_plots_occupied_on_map
      @garden[@starting_x, @starting_y] = self
      @positions_occupied = [[@starting_x, @starting_y]]
      @perimeter = []

      mark_plots_occupied_from_position(@starting_x, @starting_y)
    end

    def mark_plots_occupied_from_position(x, y)
      Map::Directions.each do |direction|
        trial_x = x + direction.delta_x
        trial_y = y + direction.delta_y
        valid_coordinate = @garden.valid_coordinate?(trial_x, trial_y)

        if valid_coordinate && @garden[trial_x, trial_y] == designator
          @garden[trial_x, trial_y] = self
          @positions_occupied << [trial_x, trial_y]
          mark_plots_occupied_from_position(trial_x, trial_y)
        end
        if !valid_coordinate || @garden[trial_x, trial_y] != self
          @perimeter << [x, y, direction]
        end
      end
    end
  end
end
