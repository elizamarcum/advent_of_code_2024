class Day1
  def self.part1(input)
    input = input.split(//).map(&:to_i)
    pairs = input.zip(input.rotate)
    output = pairs.inject(0) do |sum, pair|
      addend = (pair.first == pair.last) ? pair.first : 0
      sum + addend
    end
    output
  end

  def self.part2(input)
    input = input.split(//).map(&:to_i)
    pairs = input.zip(input.rotate(input.length/2))
    output = pairs.inject(0) do |sum, pair|
      addend = (pair.first == pair.last) ? pair.first : 0
      sum + addend
    end
    output
  end
end
