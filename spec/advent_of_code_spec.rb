require_relative 'spec_helper'

describe "advent_of_code.rb" do
  it "accepts command line arguments" do
    shell_output = `ruby advent_of_code.rb 1 1`
    expected_output = <<EOS
= Day 1, Part 1:
1941353
EOS
    _(shell_output).must_equal(expected_output)
  end
end
