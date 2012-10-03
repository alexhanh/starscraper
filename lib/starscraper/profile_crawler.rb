require 'httparty'
require 'nokogiri'

module Starscraper  
  class ProfileCrawler
    include HTTParty

    headers "User-Agent" => "Starscraper/#{VERSION}"

    def self.crawl(url)
      cookies "int-SC2" => "1"
      
      begin
        response = ProfileCrawler.get(url + 'ladder/')
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
      rescue StandardError => e
        # Parsing failed
        puts e
        return nil
      end
      
      # Handle HOTS promotion
      return nil if (doc.at_css("#intercept"))

      # Page doesn't have profile data, stop here
      return nil if doc.at_css("#profile-wrapper").nil?

      data = {}
      
      # Portrait
      portrait_css = doc.at_css("#portrait").at_css(".icon-frame")["style"].split(" ")
      sheet = portrait_css[1][/portraits\/(\d)/, 1]
      offset_x = portrait_css[2].gsub(/px/, '')
      offset_y = portrait_css[3].gsub(/px/, '')

      data["portrait"] = {:sheet => sheet, :x => offset_x, :y => offset_y}
      
      ladder_css = doc.at_css('#ladder-spotlight')
      rank = ladder_css.at_css('.division').text.strip
      
      return data if rank == "Not Yet Ranked"

      rank = rank.split("\r")[1].split(" ")[1].strip
      league = ladder_css.at_css('.league').text.split("\r")[1].strip

      data['1v1_league'] = league.capitalize
      data['1v1_rank'] = rank.to_i
      # for league in 1..4
      #   best_team = doc.at_css('#best-team-' + league.to_s)
      #   current_rank = best_team.at_css('div:eq(2)')
      #   league_type = nil
      #   if current_rank
      #     league_type = best_team.parent.at_css('span:eq(1)')["class"].split(" ")[1].split("-")[1]
      #   end
      # 
      #   key = "#{league}v#{league}"
      # 
      #   # Not yet ranked
      #   data[key + "_league"] = nil 
      # 
      #   next if league_type.nil?
      # 
      #   data[key + "_league"] = league_type.capitalize
      # 
      #   tokens = current_rank.inner_html.split('<br>')
      #   data[key + "_rank"] = tokens[1].split('</strong>')[1].strip.to_i
      # end

  		data
    end
  end
end