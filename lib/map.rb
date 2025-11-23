require 'matrix'
require 'delegate'

class Map < SimpleDelegator
  def initialize(input)
    grid = (input.is_a? Array)? input : input.split(/\n/).map{ |line| line.split(//) }
    super(Matrix[*grid])
  end

  def find_all(*args)
    return find_all(){|item| args.include? item} unless args.empty?
    each_with_index.map do |item, x, y|
      [x, y] if yield(item)
    end.compact
  end

  def valid_coordinate?(x, y)
    x >= 0  && x < column_count && y >= 0 && y < row_count
  end

  class Directions
    attr_reader :name, :delta_x, :delta_y

    def initialize(name, delta_x, delta_y)
      @name = name
      @delta_x = delta_x
      @delta_y = delta_y
    end

    def next
      case name
      when :north
        Directions.east
      when :east
        Directions.south
      when :south
        Directions.west
      when :west
        Directions.north
      end
    end

    def previous
      case name
      when :north
        Directions.west
      when :east
        Directions.north
      when :south
        Directions.east
      when :west
        Directions.south
      end
    end

    def of(x, y)
      return [x + delta_x, y + delta_y]
    end

    def to_s
      name.to_s
    end

    def self.all
      return @@directions if defined?(@@directions)
      @@directions = [south, east, north, west]
    end

    def self.east
      @@east ||= self.new(:east, 0, 1)
    end

    def self.west
      @@west ||= self.new(:west, 0, -1)
    end

    def self.north
      @@north ||= self.new(:north, -1, 0)
    end

    def self.south
      @@south ||= self.new(:south, 1, 0)
    end

    def self.each(&block)
      all.each(&block)
    end
  end
end
