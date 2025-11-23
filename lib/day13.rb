class Day13
  def self.part1(input)
    inputs = input.split(/\n{2,}/)
    machines = inputs.map{ |input| ClawMachine.new(input) }
    machines.map(&:minimum_win_cost).compact.sum
  end

  def self.part2(input)
    inputs = input.split(/\n{2,}/)
    machines = inputs.map{ |input| ClawMachine.new(input, apply_input_correction: true) }
    machines.map(&:minimum_win_cost).compact.sum
  end

  class ClawMachine
    attr_reader :a_delta_x, :a_delta_y, :b_delta_x, :b_delta_y, :goal_x, :goal_y
    INPUT_CORRECTION = 10000000000000

    def initialize(input, apply_input_correction: false)
      a_line, b_line, goal_line = input.split("\n")
      regex = /X.(\d+), Y.(\d+)/
      @a_delta_x, @a_delta_y = a_line.match(regex).captures.map(&:to_i)
      @b_delta_x, @b_delta_y = b_line.match(regex).captures.map(&:to_i)
      @goal_x, @goal_y = goal_line.match(regex).captures.map(&:to_i)
      if apply_input_correction
        @goal_x += INPUT_CORRECTION
        @goal_y += INPUT_CORRECTION
      end
    end

    def cost_of(a_presses, b_presses)
      a_cost = 3
      b_cost = 1
      (a_cost * a_presses) + (b_cost * b_presses)
    end

    def is_solveable?
      minimum_win_cost != nil
    end

    def minimum_win_cost
      # My pre-Google noodling
      # cost = 3a_presses + 1b_presses
      # goal_x = a_dx * a_presses + b_dx * b_presses
      # goal_y = a_dy * a_presses + b_dy * b_presses

      # Post-Google I was reminded that I did not do
      # well in Linear Algebra class.
      #
      # https://en.wikipedia.org/wiki/Cramer%27s_rule
      # Honestly, making me (try/fail) to learn new math was rude.
      #
      # a1x + b1y = c1
      # a2x + b2y = c2
      # converts to:
      # x = c1b2 - b1c2 / a1b2 - b1a2
      # y = a1c2 - c1a2 / a1b2 - b1a2
      #
      # ====== My version of the equation:
      #
      # a_dx * a_presses + b_dx * b_presses = goal_x
      # a_dy * a_presses + b_dy * b_presses = goal_y
      #
      # ====== Substituting in my variables:
      #
      # a1 = a_dx; x = a_presses; b1 = b_dx; c1 = goal_x
      # a2 = a_dy; b2 = b_dy; c2 = goal_y

      # a_presses = goal_x * b_dy - b_dx * goal_y / a_dx * b_dy - b_dx * a_dy
      # b_presses = a_dx * goal_y - goal_x * a_dy / a_dx * b_dy - b_dx * a_dy
      #
      # ====== The actual math
      a_presses = (goal_x * b_delta_y - b_delta_x * goal_y) / (a_delta_x * b_delta_y - b_delta_x * a_delta_y)
      b_presses = (a_delta_x * goal_y - goal_x * a_delta_y) / (a_delta_x * b_delta_y - b_delta_x * a_delta_y)
      return nil if a_presses > 100 || b_presses > 100
      cost_of(a_presses, b_presses)
    end
  end
end
