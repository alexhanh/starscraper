require "starscraper/version"

module Starscraper
  require 'starscraper/profile_crawler'
  
  def self.profile(url)
    ProfileCrawler.crawl(url)
  end
end
