require 'matrix'
require 'delegate'

class GeneralMap < SimpleDelegator
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
end
