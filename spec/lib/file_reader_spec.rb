# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/file_reader'

describe FileReader do
  describe '#initialize' do
    context 'file not found' do
      subject { described_class.new(file_path: '_.log') }
      it 'panics with file not found error' do
        expect { subject }.to raise_error(FileNotFoundError)
      end
    end

    context 'error reading file' do
      subject { described_class.new(file_path: 'spec/fixtures/webserver.log') }
      it 'panics with UnableToOpenFileError if wasnt able to read file' do
        expect_any_instance_of(File).to receive(:read).and_raise(StandardError)
        expect { subject }.to raise_error(UnableToOpenFileError)
      end
    end
  end

  describe '#read_lines' do
    context 'line with correct format' do
      subject { described_class.new(file_path: 'spec/fixtures/webserver.log') }
      it 'returns parsed lines' do
        result = subject.read_lines
        expect(result).to include(
          %w[/home 2.2.2.2],
          %w[/help_page/1 1.1.1.1],
          %w[/home 1.1.1.1],
          %w[/contact 2.2.2.2],
          %w[/contact 1.1.1.1],
          %w[/about/2 3.3.3.3]
        )
      end
    end

    context 'logfile contains empty lines' do
      subject { described_class.new(file_path: 'spec/fixtures/webserver_empty_lines.log') }
      it 'returns parsed lines' do
        result = subject.read_lines
        expect(result).to include(
          %w[/home 2.2.2.2],
          %w[/help_page/1 1.1.1.1],
          %w[/home 1.1.1.1],
          %w[/contact 2.2.2.2],
          %w[/contact 1.1.1.1],
          %w[/about/2 3.3.3.3]
        )
      end
    end

    context 'logfile contains error lines' do
      subject { described_class.new(file_path: 'spec/fixtures/webserver_error_lines.log') }
      let(:errors) do
        <<~INFO
          Error parsing line #: 1;
          Error parsing line #: 3;
          Error parsing line #: 4;
          Error parsing line #: 5;
          Error parsing line #: 7;
        INFO
      end
      it 'prints error messages' do
        expect { subject.read_lines }.to output(a_string_including(errors)).
          to_stderr_from_any_process
      end

      it 'still processes correct lines' do
        expect(subject.read_lines).to include(
          ['/about/2', '3.3.3.3']
        )
      end
    end
  end
end
