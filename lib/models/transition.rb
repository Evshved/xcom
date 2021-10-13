# frozen_string_literal: true

class Transition
  attr_reader :from, :to
  attr_accessor :weight

  def initialize(from:, to:, weight:)
    @from = from
    @to = to
    @weight = weight
  end

  def to_s
    "Transitions from #{from} to #{to} - #{weight} time(s)"
  end
end
