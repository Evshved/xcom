# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/lines_formatter'

describe LinesFormatter do
  let(:lines) {
    [
      %w[/home 2.2.2.2],
      %w[/help_page/1 1.1.1.1],
      %w[/home 1.1.1.1],
      %w[/contact 2.2.2.2],
      %w[/contact 1.1.1.1],
      %w[/about/2 3.3.3.3]
    ]
  }

  describe '#group_by_pages' do
    subject { described_class.new(lines) }
    it 'returns grouped lines by pages' do
      result = subject.group_by_pages
      expect(result).to include(
        '/home' => ['2.2.2.2', '1.1.1.1'],
        '/contact' => ['2.2.2.2', '1.1.1.1'],
        '/help_page/1' => ['1.1.1.1'],
        '/about/2' => ['3.3.3.3']
      )
    end
  end

  describe '#group_by_ips' do
    subject { described_class.new(lines) }
    it 'returns grouped lines by pages' do
      result = subject.group_by_ips
      expect(result).to include(
        '2.2.2.2' => ['/home', '/contact'],
        '1.1.1.1' => ['/help_page/1', '/home', '/contact'],
        '3.3.3.3' => ['/about/2']
      )
    end
  end
end
