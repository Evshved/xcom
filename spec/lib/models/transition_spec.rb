# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/models/transition'

describe Transition do
  describe '#to_s' do
    subject { described_class.new(from: '/minsk', to: '/london', weight: 1) }
    it 'returns formatted string for the transition' do
      result = subject.to_s
      expect(result).to eq('Transitions from /minsk to /london - 1 time(s)')
    end
  end
end
