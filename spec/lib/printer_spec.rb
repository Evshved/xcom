# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/printer'
require_relative '../../lib/models/page_view'
require_relative '../../lib/models/transition'

describe Printer do
  let(:page_views_data) do
    [
      PageView.new(page: '/test', ips: ['1.1.1.1', '2.2.2.2']),
      PageView.new(page: '/test/1', ips: ['1.1.1.1', '2.2.2.2'])
    ]
  end
  let(:transitions_data) do
    [
      Transition.new(from: '/index', to: '/about', weight: 5),
      Transition.new(from: '/about', to: '/contacts', weight: 2)
    ]
  end

  describe '#print' do
    it 'prints divider for each set of data' do
      expect { subject.print('test', page_views_data) }.
        to output(a_string_including('=' * 80)).to_stdout
    end

    it 'prints provided title' do
      expect { subject.print('Some Title', transitions_data) }.
        to output(a_string_including('Some Title')).to_stdout
    end
  end
end
