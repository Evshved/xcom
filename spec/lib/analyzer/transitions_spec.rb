# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/analyzer/transitions'
require_relative '../../../lib/lines_formatter'

describe Analyzer::Transitions do
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
    it 'returns Transition object defined transition between routes' do
      result = subject.run
      expect(result.length).to eq(4)
      expect(result.first).to be_an_instance_of(Transition)
    end
    it 'correctly calculates transitions amount(weight) for not uniq transition' do
      result = subject.run
      home_to_contact_transition = result.find { |el| el.from == '/home' && el.to == '/contact' }
      expect(home_to_contact_transition.weight).to eq(2)
    end
    it 'correctly calculates transitions amount(weight) for uniq transition' do
      result = subject.run
      help_to_home_transition = result.find { |el| el.from == '/help_page/1' && el.to == '/home' }
      expect(help_to_home_transition.weight).to eq(1)
    end
    it 'doesnt return transition between pages if :to is missing' do
      result = subject.run
      empty_to_transitions = result.find { |el| el.to.nil? }
      expect(empty_to_transitions).to eq(nil)
    end
  end
end
