# frozen_string_literal: true

require_relative '../../lib/log_analyzer'
require_relative '../../lib/printer'
require_relative '../../lib/models/page_view'
require_relative '../../lib/models/transition'

describe LogAnalyzer do
  describe '#analyze' do
    let(:reader) { double(:reader) }
    let(:lines) {
      [
        ['/home', '2.2.2.2'],
        ['/help_page/1', '1.1.1.1'],
        ['/home', '1.1.1.1'],
        ['/contact', '2.2.2.2'],
        ['/contact', '1.1.1.1'],
        ['/about/2', '3.3.3.3']
      ]
    }
    subject do
      described_class.new(reader: reader)
    end

    before do
      allow(reader).to receive(:read_lines)
        .and_return(lines)

      allow_any_instance_of(Analyzer::SortByCount).to receive(:run)
        .and_return(
          [
            PageView.new(page: '/home', ips: ['2.2.2.2', '1.1.1.1']),
            PageView.new(page: '/contact', ips: ['2.2.2.2', '1.1.1.1']),
            PageView.new(page: '/help_page/1', ips: ['1.1.1.1']),
            PageView.new(page: '/about/2', ips: ['3.3.3.3'])
          ]
        )
      allow_any_instance_of(Analyzer::UniqVisits).to receive(:run)
        .and_return(
          [
            PageView.new(page: '/home', ips: ['2.2.2.2', '1.1.1.1']),
            PageView.new(page: '/contact', ips: ['2.2.2.2', '1.1.1.1']),
            PageView.new(page: '/help_page/1', ips: ['1.1.1.1']),
            PageView.new(page: '/about/2', ips: ['3.3.3.3'])
          ]
        )
      allow_any_instance_of(Analyzer::Transitions).to receive(:run)
        .and_return(
          [
            Transition.new(from: '/home', to: '/contact', weight: 2),
            Transition.new(from: '/help_page/1', to: '/contact', weight: 1)
          ]
        )

      allow(Printer).to receive(:print)
    end

    after { subject.analyze }

    it 'calls #read_lines of reader and sends this data to LinesFormatter' do
      expect(reader).to receive(:read_lines)
        .and_return(lines)
      expect(LinesFormatter).to receive(:new).with(lines)
    end

    it 'gets calculated stats from analyzer services' do
      expect_any_instance_of(Analyzer::SortByCount).to receive(:run)
      expect_any_instance_of(Analyzer::UniqVisits).to receive(:run)
      expect_any_instance_of(Analyzer::Transitions).to receive(:run)
    end

    it 'calls #print of printer for each set of data' do
      expect(Printer).to receive(:print).exactly(3).times
    end
  end
end
