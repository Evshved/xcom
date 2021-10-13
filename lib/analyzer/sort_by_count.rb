# frozen_string_literal: true

require_relative '../models/page_view'
module Analyzer
  class SortByCount
    def initialize(line_formatter)
      @line_formatter = line_formatter
    end

    def run
      prepared = @line_formatter.group_by_pages
      prepared = prepared.to_a.map { |line| PageView.new(page: line[0], ips: line[1]) }
      prepared.sort { |a, b| b.ips.count <=> a.ips.count }
    end
  end
end
