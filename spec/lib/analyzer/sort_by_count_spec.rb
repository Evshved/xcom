# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/analyzer/sort_by_count'
require_relative '../../../lib/lines_formatter'

describe Analyzer::SortByCount do
  describe '#run' do
    let(:lines) do
      [
        %w[/help_page/1 1.1.1.1],
        %w[/about/2 3.3.3.3],
        %w[/home 2.2.2.2],
        %w[/home 1.1.1.1],
        %w[/contact 2.2.2.2],
        %w[/contact 1.1.1.1]
      ]
    end
    let(:line_formatter) { LinesFormatter.new(lines) }
    subject { described_class.new(line_formatter) }
    it 'returns PageView object for each page' do
      result = subject.run
      expect(result.length).to eq(4)
      expect(result.first).to be_an_instance_of(PageView)
    end

    it 'returns sorted array of PageViews' do
      result = subject.run
      expect(result.first.page).to eq('/home')
      expect(result.first.ips).to eq(%w[2.2.2.2 1.1.1.1])
      expect(result.last.page).to eq('/about/2')
      expect(result.last.ips).to eq(%w[3.3.3.3])
    end

    it 'returns sorts page views by amount of ips' do
      result = subject.run
      expect(result.first.page).not_to eq('/help_page/1')
      expect(result.first.ips.length).to be > result.last.ips.length
    end
  end
end
