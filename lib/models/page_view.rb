# frozen_string_literal: true

class PageView
  attr_reader :page, :ips

  def initialize(page:, ips:)
    @page = page
    @ips = ips
  end

  def to_s
    "page: #{page}, views: #{ips.count}"
  end
end
