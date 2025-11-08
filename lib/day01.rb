class Day1
  def self.part1(input)
    input = input.split(/\n/).map do |line|
      line.split(/\s+/).map(&:to_i)
    end
    left_side, right_side = input.transpose
    left_side.sort!
    right_side.sort!
    pairs = left_side.zip(right_side)
    output = pairs.inject(0) do |sum, pair|
      sum + (pair.last - pair.first).abs
    end
    output
  end

  def self.part2(input)
  end
end
