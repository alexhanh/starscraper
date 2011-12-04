require 'httparty'
require 'nokogiri'

module Starscraper  
  class ProfileCrawler
    include HTTParty

    headers "User-Agent" => "Starscraper/#{VERSION}"

    def self.crawl(url)
      cookies "int-SC2" => "1"
      
      begin
        response = ProfileCrawler.get(url)
      rescue StandardError
        return nil
      end
      
      # Only continue if HTTP response code is 200 (OK).
      if response.code != 200
        puts response.code
        return nil
      end
      
      begin
        doc = Nokogiri::HTML(response.body)
      rescue StandardError
        # Parsing failed
        return nil
      end
      
      # Handle HOTS promotion
      return nil if (doc.at_css("#intercept"))

      # Page doesn't have profile data, stop here
      return nil if doc.at_css("#profile-wrapper").nil?

      data = {}
      
      # Not ranked yet
      if (doc.at_css(".snapshot-empty"))
        return data
      end

      for league in 1..4
        best_team = doc.at_css('#best-team-' + league.to_s)
        current_rank = best_team.at_css('div:eq(2)')
        league_type = nil
        if current_rank
          league_type = best_team.parent.at_css('span:eq(1)')["class"].split(" ")[1].split("-")[1]
        end

        key = "#{league}v#{league}"

        # Not yet ranked
        data[key + "_league"] = nil 

        next if league_type.nil?

        data[key + "_league"] = league_type.capitalize

        tokens = current_rank.inner_html.split('<br>')
        data[key + "_rank"] = tokens[1].split('</strong>')[1].strip.to_i
      end

  		data
    end
  end
end