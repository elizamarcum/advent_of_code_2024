class Day5
  def self.part1(input)
    rule_list, sets_of_pages_to_print = parse_input(input)
    rules = PageOrderingRules.new(rule_list)
    valid_page_sets = sets_of_pages_to_print.keep_if{ |pages| !rules.invalidates?(pages) }
    valid_page_sets.map{ |pages| pages[pages.length / 2] }.sum
  end

  def self.part2(input)
    "TBD"
  end

  class PageOrderingRules
    def initialize(rule_list)
      @rules = rule_list
    end

    def invalidates?(page_list)
      @rules.any?{|rule| breaks_rule?(page_list, rule)}
    end

    private

    def breaks_rule?(page_list, rule)
      earlier, later = rule
      earlier_position = page_list.index(earlier)
      return false unless earlier_position
      later_position = page_list.index(later)
      return false unless later_position
      earlier_position > later_position
    end
  end

  private

  def self.parse_input(input)
    rule_list, page_list = input.split(/^\s+/)
    parsed_rules = rule_list.split(/\n/).map{|line| line.split("|").map(&:to_i)}
    parsed_page_list = page_list.split(/\n/).map{|line| line.split(",").map(&:to_i)}
    [parsed_rules, parsed_page_list]
  end
end
