# frozen_string_literal: true

require_relative '../models/transition'
module Analyzer
  class Transitions
    def initialize(line_formatter)
      @line_formatter = line_formatter
    end

    def run
      grouped_data = @line_formatter.group_by_ips
      build_transitions(grouped_data)
    end

    private

    def build_transitions(grouped_pathes)
      transitions = []
      grouped_pathes.each do |_ip, pages|
        analyze_transitions_for_ip(pages, transitions)
      end
      transitions
    end

    def analyze_transitions_for_ip(pages, transitions)
      pages.each_with_index do |_page, index|
        break if pages[index.next].nil?

        if (existed = find_transition_through_same_route(transitions, pages, index))
          existed.weight += 1
        else
          transitions << Transition.new(from: pages[index], to: pages[index.next], weight: 1)
        end
      end
    end

    def find_transition_through_same_route(transitions, pages, index)
      transitions.find { |el| el.from == pages[index] && el.to == pages[index.next] }
    end
  end
end
