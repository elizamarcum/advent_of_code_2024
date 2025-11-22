require_relative 'general_map'

class Day12
  def self.part1(input)
    garden = Garden.new(input)
    garden.total_fencing_cost
  end

  def self.part2(input)
    "TBD"
  end

  class Garden < GeneralMap
    attr_reader :plots

    def initialize(input)
      super(input)
      @plots = []
      each_with_index do |plot, x, y|
        # puts "Contemplating plot #{plot} at #{x}, #{y}"
        next if plot.is_a? GardenPlot
        @plots << GardenPlot.new(self, plot, x, y)
      end
    end

    def total_fencing_cost
      plots.sum(&:fencing_cost)
    end
  end

  class GardenPlot
    attr_reader :area, :designator, :perimeter

    def initialize(garden, plot_designator, starting_x, starting_y)
      @garden = garden
      @designator = plot_designator
      @starting_x = starting_x
      @starting_y = starting_y
      mark_plots_occupied_on_map
      @area = @positions_occupied.count
    end

    def fencing_cost
      area * perimeter
    end

    def to_s
      "#{designator} #{@positions_occupied}"
    end

    private

    # Replace each spot of map for which this GardenPlot applies
    # with a reference to this GardenPlot
    def mark_plots_occupied_on_map
      @garden[@starting_x, @starting_y] = self
      @positions_occupied = [[@starting_x, @starting_y]]
      @perimeter = 0

      mark_plots_occupied_from_position(@starting_x, @starting_y)
    end

    def mark_plots_occupied_from_position(x, y)
      variants = [ [1, 0], [0, 1], [-1, 0], [0, -1]]
      variants.each do |variant|
        delta_x, delta_y = variant
        trial_x = x + delta_x
        trial_y = y + delta_y
        valid_coordinate = @garden.valid_coordinate?(trial_x, trial_y)
        if valid_coordinate && @garden[trial_x, trial_y] == designator
          @garden[trial_x, trial_y] = self
          @positions_occupied << [trial_x, trial_y]
          mark_plots_occupied_from_position(trial_x, trial_y)
        end
        if !valid_coordinate || @garden[trial_x, trial_y] != self
          @perimeter += 1
        end
      end
    end
  end
end
