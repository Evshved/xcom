# frozen_string_literal: true

require_relative 'lines_formatter'
require_relative 'analyzer/sort_by_count'
require_relative 'analyzer/uniq_visits'
require_relative 'analyzer/transitions'

class LogAnalyzer
  def initialize(reader:, printer:)
    @reader = reader
    @printer = printer
  end

  def analyze
    lines = @reader.read_lines
    lines_formatter = LinesFormatter.new(lines)

    analyzed_data = Analyzer::SortByCount.new(lines_formatter).run
    @printer.print('Sorted views:', analyzed_data)

    analyzed_data = Analyzer::UniqVisits.new(lines_formatter).run
    @printer.print('Unique views', analyzed_data)

    analyzed_data = Analyzer::Transitions.new(lines_formatter).run
    @printer.print('Transitions map', analyzed_data)
  end
end
