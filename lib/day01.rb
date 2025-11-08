class Day1
  def self.parse_input(input)
    input.split(/\n/).map do |line|
      line.split(/\s+/).map(&:to_i)
    end
  end

  def self.part1(input)
    left_side, right_side = self.parse_input(input).transpose
    left_side.sort!
    right_side.sort!
    pairs = left_side.zip(right_side)
    output = pairs.inject(0) do |sum, pair|
      sum + (pair.last - pair.first).abs
    end
    output
  end

  def self.part2(input)
    left_side, right_side = self.parse_input(input).transpose
    frequency = right_side.tally
    similarity_scores = left_side.map do
      |number| number * (frequency[number] || 0)
    end
    similarity_scores.reduce(:+)
  end
end
