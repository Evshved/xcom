# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/models/page_view'

describe PageView do
  describe '#to_s' do
    subject { described_class.new(page: 'my_page', ips: ['1.2.3.4', '8.8.8.8']) }
    it 'returns string including page info and ips count' do
      result = subject.to_s
      expect(result).to eq('page: my_page, views: 2')
    end
  end
end
