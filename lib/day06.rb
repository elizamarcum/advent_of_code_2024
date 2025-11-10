require 'matrix'

class Day6
  def self.part1(input)
    guard = Guard.new(input)
    while guard.on_grid?
      guard.travel!
    end
    guard.unique_positions_patrolled_count
  end

  def self.part2(input)
    "TBD"
  end

  private

  class Guard
    attr_reader :grid
    MARK = 'X'
    OBSTRUCTION = '#'
    RULES = [
      {symbol: '^', x_inc: -1, y_inc:  0, next_symbol: '>'},
      {symbol: '>', x_inc:  0, y_inc:  1, next_symbol: 'v'},
      {symbol: 'v', x_inc:  1, y_inc:  0, next_symbol: '<'},
      {symbol: '<', x_inc:  0, y_inc: -1, next_symbol: '^'}
    ]

    def initialize(input)
      grid = input.split(/\n/).map{ |line| line.split(//) }
      @grid = Matrix[*grid]
      @current_x, @current_y = discover_current_position
      @current_direction = find_current_direction
    end

    def current_map(with_path: false)
      @grid.to_a.map{ |row| row.map{ |char| (!with_path && char == MARK)? '.' : char }.join }.join("\n")
    end

    def on_grid?
      @current_x >= 0 && @current_x < @grid.column_count && @current_y >= 0 && @current_y < @grid.row_count
    end

    def travel!
      if travel_obstructed?
        turn!
      end
      until travel_obstructed? or !on_grid?
        move_forward!
      end
    end

    def unique_positions_patrolled_count
      count = 0
      @grid.each{|cell| count += 1 if cell == MARK }
      count
    end

    private

    def find_current_direction
      return unless @current_x and @current_y
      RULES.find{|rule| rule[:symbol] == @grid[@current_x, @current_y] }
    end

    def discover_current_position
      RULES.map{ |rule| @grid.index(rule[:symbol]) }.compact.first
    end

    def move_forward!
      @grid[@current_x, @current_y] = MARK
      @current_x += @current_direction[:x_inc]
      @current_y += @current_direction[:y_inc]
      @grid[@current_x, @current_y] = @current_direction[:symbol] if on_grid?
    end

    def travel_obstructed?
      next_x = @current_x + @current_direction[:x_inc]
      next_y = @current_y + @current_direction[:y_inc]
      @grid[next_x, next_y] == OBSTRUCTION
    end

    def turn!
      @grid[@current_x, @current_y] = @current_direction[:next_symbol]
      @current_direction = find_current_direction
    end
  end
end
