require 'net/http'
require 'nokogiri'

class IssuesCheckerError < StandardError; end

class IssuesChecker
  attr_reader :opened, :closed

  def initialize(repo)
    @repo = repo
    @opened = 0
    @closed = 0
  end

  def check
    res = Net::HTTP.get_response(issues_url)
    raise IssuesCheckerError.new("Failed to fetch repository info: #{@repo}") unless res.is_a?(Net::HTTPSuccess)
    html_doc = Nokogiri::HTML(res.body)
    issues_count = html_doc.css('.js-selected-navigation-item.reponav-item.selected .counter').first.text.to_i
    return unless issues_count > 0
    @opened, @closed = html_doc.css('.table-list-header-toggle.states.left a').map do |el| 
      el.text.gsub(',', '').scan(/\d+/)
    end.flatten.map(&:to_i)
  end


  private 

  def issues_url
    URI("https://github.com/#{@repo}/issues")
  end


end
