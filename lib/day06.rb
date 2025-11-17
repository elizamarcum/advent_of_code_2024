require_relative 'general_map'

class Day6
  def self.part1(input)
    map = Map.new(input)
    guard = Guard.new(map)
    guard.travel_indefinitely!
    guard.unique_positions_patrolled_count
  end

  def self.part2(input)
    template = Map.new(input)
    starting_map = Map.new(input)
    guard = Guard.new(starting_map)
    guard.travel_indefinitely!
    coordinates_to_test = starting_map.each_with_index.map do |item, x, y|
      [x, y] if item == Map::MARK
    end.compact

    coordinates_to_test.count do |pair|
      x, y = pair
      updated_grid = template.to_a
      updated_grid[x][y] = Map::ADDED_OBSTRUCTION
      test_map = Map.new(updated_grid)
      Guard.new(test_map).travel_indefinitely!
      test_map.loop_detected?
    end
  end

  private

  class Guard
    def initialize(map)
      @map = map
      @x, @y = discover_current_position
      if on_map?
        @direction = Day6::Guard::RULES.find{|rule| rule[:symbol] == @map[@x, @y] }
      end
    end

    def current_map(with_path: false)
      @map.to_a(with_path: with_path)
    end

    def travel!
      if travel_obstructed?
        turn!
      end
      while can_continue_traveling? and !travel_obstructed?
        move_forward!
      end
    end

    def travel_indefinitely!
      while can_continue_traveling?
        travel!
      end
    end

    def can_continue_traveling?
      on_map? and !@map.loop_detected?
    end

    def unique_positions_patrolled_count
      @map.count{ |cell| cell == Day6::Map::MARK }
    end

    private

    def self.calculate_rules
      west_rule = {symbol: '<', x_inc:  0, y_inc: -1}
      south_rule = {symbol: 'v', x_inc:  1, y_inc:  0, next_rule: west_rule}
      east_rule = {symbol: '>', x_inc:  0, y_inc:  1, next_rule: south_rule}
      north_rule = {symbol: '^', x_inc: -1, y_inc:  0, next_rule: east_rule}
      west_rule[:next_rule] = north_rule
      [north_rule, east_rule, south_rule, west_rule]
    end
    RULES = Day6::Guard::calculate_rules

    def discover_current_position
      direction_symbols = RULES.map{ |rule| rule[:symbol] }
      @map.index{ |char| direction_symbols.include? char }
    end

    def move_forward!
      @map.mark_leaving!(@x, @y)
      @x += @direction[:x_inc]
      @y += @direction[:y_inc]
      @map.mark_entering!(@x, @y, @direction[:symbol])
    end

    def on_map?
      return false unless @x && @y
      @map.valid_coordinate?(@x, @y)
    end

    def travel_obstructed?
      next_x = @x + @direction[:x_inc]
      next_y = @y + @direction[:y_inc]
      @map.can_stand_at?(next_x, next_y)
    end

    def turn!
      @direction = @direction[:next_rule]
      @map.mark_turning!(@x, @y, @direction[:symbol])
    end
  end

  class Map < GeneralMap
    OPEN_SPACE = '.'
    MARK = 'X'
    NATURAL_OBSTRUCTION = '#'
    ADDED_OBSTRUCTION = 'O'

    def initialize(input)
      super(input)
      @loop_detected = false
      @visit_list = Set.new()
    end

    def can_stand_at?(x, y)
      [NATURAL_OBSTRUCTION, ADDED_OBSTRUCTION].include? self[x, y]
    end

    def loop_detected?
      @loop_detected
    end

    def mark_entering!(x, y, direction)
      return unless valid_coordinate?(x, y)
      record_visit_to(x, y, direction)
      self[x, y] = direction
    end

    def mark_leaving!(x, y)
      self[x, y] = MARK
    end

    def mark_turning!(x, y, direction)
      mark_entering!(x, y, direction)
    end

    def to_a(with_path: false)
      if with_path
        super()
      else
        # NOTE: Now that this is a proper class, we can probably avoid making the interim arrays
        super().map{ |row| row.map{ |char| (char == Day6::Map::MARK)? OPEN_SPACE : char } }
      end
    end

    private

    def record_visit_to(x, y, direction)
      visit = [x, y, direction]
      @loop_detected = !@visit_list.add?(visit)
    end
  end
end
