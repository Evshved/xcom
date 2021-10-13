# frozen_string_literal: true

module Printer
  def self.print(title, data)
    puts '=' * 80
    puts title
    data.each do |line|
      puts line.to_s
    end
  end
end
