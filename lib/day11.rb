class Day11
  def self.part1(input)
    blink!(input, 25)
  end

  def self.part2(input)
    blink!(input, 75)
  end

  def self.blink!(input, n)
    stones = PhysicsDefyingStones.new(input)
    n.times do |i|
      puts "Blink #{i+1} of #{n}"
      stones.blink!
    end
    stones.count
  end

  class PhysicsDefyingStones
    attr_reader :stones

    def initialize(input)
      @stones = input.split(" ").map(&:to_i)
    end

    def blink!
      new_stones = []
      @stones.each do |stone|
        if stone == 0
          # If the stone is engraved with the number 0, it is replaced by a stone engraved
          # with the number 1.
          new_stones << 1
        else
          digits = stone.to_s
          if digits.length.even?
            # If the stone is engraved with a number that has an even number of digits, it is
            # replaced by two stones. The left half of the digits are engraved on the new left
            # stone, and the right half of the digits are engraved on the new right stone. (The
            # new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
            new_stones << digits.slice!(0...digits.length/2).to_i
            new_stones << digits.to_i
          else
            # If none of the other rules apply, the stone is replaced by a new stone; the old
            # stone's number multiplied by 2024 is engraved on the new stone.
            new_stones << stone * 2024
          end
        end
      end

      @stones = new_stones
    end

    def count
      @stones.count
    end

    def inspect
      "#<PhysicsDefyingStones::#{object_id} #{to_s}>"
    end

    def to_s
      @stones.map(&:to_s).join(" ")
    end

    def ==(other)
      return false unless other.is_a? PhysicsDefyingStones
      @stones == other.stones
    end
  end
end
