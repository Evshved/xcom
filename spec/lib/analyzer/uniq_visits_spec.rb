# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/analyzer/uniq_visits'
require_relative '../../../lib/lines_formatter'

describe Analyzer::UniqVisits do
  describe '#run' do
    let(:lines) do
      [
        %w[/help_page/1 1.1.1.1],
        %w[/about/2 3.3.3.3],
        %w[/home 2.2.2.2],
        %w[/home 1.1.1.1],
        %w[/contact 2.2.2.2],
        %w[/contact 1.1.1.1],
        %w[/help_page/1 1.1.1.1],
        %w[/home 2.2.2.2]
      ]
    end
    let(:line_formatter) { LinesFormatter.new(lines) }
    subject { described_class.new(line_formatter) }
    it 'returns PageView object per each page' do
      result = subject.run
      expect(result.length).to eq(4)
      expect(result.first).to be_an_instance_of(PageView)
    end
    it 'returns uniq ips for page' do
      result = subject.run
      home_pageview = result.find { |el| el.page == '/home' }
      expect(home_pageview.ips.length).not_to eq(3)
      expect(home_pageview.ips.length).to eq(2)
      expect(home_pageview.ips).to include('1.1.1.1')
      expect(home_pageview.ips).to include('2.2.2.2')
      help_pageview = result.find { |el| el.page == '/help_page/1' }
      expect(help_pageview.ips.length).to eq(1)
      expect(help_pageview.ips).to eq(['1.1.1.1'])
    end
  end
end
