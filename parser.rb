#!/usr/bin/ruby
# frozen_string_literal: true

require_relative 'lib/file_reader'
require_relative 'lib/log_analyzer'
require_relative 'lib/exceptions'

if ARGV.empty?
  warn('ERROR: One argument missed.')
  exit 1
end

log_file_path = ARGV[0]

begin
  reader = FileReader.new(file_path: log_file_path)
rescue FileNotFoundError
  warn('ERROR: File not found')
  exit 1
rescue UnableToOpenFileError
  warn('ERROR: Unable to open file')
  exit 1
end

LogAnalyzer.new(reader: reader).analyze
