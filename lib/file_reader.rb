# frozen_string_literal: true

require_relative 'exceptions'
class FileReader
  def initialize(file_path:)
    raise FileNotFoundError unless File.exist?(file_path)

    @content = get_file_content(file_path)
    @lines = []
  end

  def read_lines
    return @lines unless @lines.empty?

    @content.each_line.with_index do |line, index|
      begin
        info = line.split(' ')
        validate_info(info)
        @lines << info
      rescue EmptyLineError
        next
      rescue WrongArgumentsError
        warn "Error parsing line #: #{index + 1};"
        next
      end
    end
    @lines
  end

  private

  def get_file_content(path)
    File.open(path).read
  rescue StandardError
    raise UnableToOpenFileError
  end

  def validate_info(info)
    raise EmptyLineError if info[0].nil?

    wrong_arguments = info.length > 2 || not_webpage?(info[0]) || not_ip?(info[1])
    raise WrongArgumentsError if wrong_arguments
  end

  def not_webpage?(page_url)
    page_url[0] != '/'
  end

  def not_ip?(possible_ip)
    possible_ip !~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
  end
end
