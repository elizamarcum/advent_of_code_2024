class Day2
  def self.parse_input(input)
    input.split(/\n/).map do |line|
      line.split(/\s+/).map(&:to_i)
    end
  end

  def self.report_safe?(numbers)
    self.numbers_all_increase_safely?(numbers) or self.numbers_all_decrease_safely?(numbers)
  end

  def self.report_safe_if_dampened?(numbers)
    return true if self.report_safe?(numbers)
    numbers.count.times do |i|
      numbers_without_item_at_i = Array.new(numbers)
      numbers_without_item_at_i.delete_at(i)
      return true if self.report_safe?(numbers_without_item_at_i)
    end
    false
  end

  def self.part1(input)
    self.parse_input(input).count{|report| self.report_safe?(report) }
  end

  def self.part2(input)
    self.parse_input(input).count{|report| self.report_safe_if_dampened?(report) }
  end

  private

  def self.numbers_all_increase_safely?(numbers)
    test = lambda do |pair|
      left, right = pair
      left < right && (right - left < 4)
    end
    numbers.each_cons(2).map(&test).all?(true)
  end

  def self.numbers_all_decrease_safely?(numbers)
    test = lambda do |pair|
      left, right = pair
      left > right && (left - right < 4)
    end
    numbers.each_cons(2).map(&test).all?(true)
  end
end
