class Day5
  def self.part1(input)
    rule_list, lists_of_pages_to_print = parse_input(input)
    rules = PageOrderingRules.new(rule_list)
    valid_page_sets = lists_of_pages_to_print.keep_if{ |list_of_pages| !rules.invalidates?(list_of_pages) }
    valid_page_sets.map{ |pages| pages[pages.length / 2] }.sum
  end

  def self.part2(input)
    rule_list, lists_of_pages_to_print = parse_input(input)
    rules = PageOrderingRules.new(rule_list)
    invalid_page_sets = lists_of_pages_to_print.keep_if{ |list_of_pages| rules.invalidates?(list_of_pages) }
    invalid_page_sets.each{ |list_of_pages| rules.repair!(list_of_pages) }
    invalid_page_sets.map{ |pages| pages[pages.length / 2] }.sum
  end

  class PageOrderingRules
    def initialize(rule_list)
      @rules = rule_list
    end

    def invalidates?(page_list)
      @rules.any?{|rule| breaks_rule?(page_list, rule)}
    end

    def repair!(page_list)
      while invalidates?(page_list) do
        broken_rules = invalidating_rules_for(page_list)
        broken_rules.each do |rule|
          earlier, later = rule
          move_before(later, earlier, page_list)
        end
      end
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

    def invalidating_rules_for(page_list)
      @rules.filter{|rule| breaks_rule?(page_list, rule)}
    end

    def move_before(later, earlier, page_list)
      page_list.delete(earlier)
      index = page_list.index(later)
      page_list.insert(index, earlier)
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
