# frozen_string_literal: true

require_relative '../models/page_view'
module Analyzer
  class UniqVisits
    def initialize(line_formatter)
      @line_formatter = line_formatter
    end

    def run
      prepared = @line_formatter.group_by_pages
      prepared.to_a.map { |line| PageView.new(page: line[0], ips: line[1].uniq) }
    end
  end
end
