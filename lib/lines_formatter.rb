# frozen_string_literal: true

class LinesFormatter
  def initialize(lines)
    @lines = lines
    @group_by_pages = []
    @group_by_ips = []
  end

  def group_by_pages
    return @group_by_pages unless @group_by_pages.empty?

    @group_by_pages = {}
    @lines.each do |line|
      if @group_by_pages[line[0]]
        @group_by_pages[line[0]] << line[1]
      else
        @group_by_pages[line[0]] = [line[1]]
      end
    end
    @group_by_pages
  end

  def group_by_ips
    return @group_by_ips unless @group_by_ips.empty?

    @group_by_ips = {}
    @lines.each do |line|
      if @group_by_ips[line[1]]
        @group_by_ips[line[1]] << line[0]
      else
        @group_by_ips[line[1]] = [line[0]]
      end
    end
    @group_by_ips
  end
end
