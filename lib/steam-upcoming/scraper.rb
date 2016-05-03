#The SteamUpcoming::Scraper class is responsible for scraping information off of the target webpage
#and outputting hashes of information to be used by the SteamUpcoming::Game class. 

class SteamUpcoming::Scraper
  attr_accessor :name, :release_date, :platforms, :url

  def self.scrape_index_page(index_url) #scrape the page and create an array of hashes (1 hash for each game)
    doc = Nokogiri::HTML(open(index_url))
    game_array = []
    doc.css(".search_result_row").each do |game|
      game_hash = {
        :name=> game.css(".title").text, 
        :release_date=> game.css(".search_released").text,  
        :platforms=> self.convert_platforms(gather_platforms(game.css(".search_name p"))), 
        :url=> game.first[1]
      }
      game_array << game_hash
    end
    game_array
  end

  def self.gather_platforms(parent) #gather a list of platforms, then return an array of legit platforms
    platforms = parent.children.map do |platform|
      platform.attr('class')
    end
    platforms.select {|platform| platform != nil} 
  end

  def self.convert_platforms(platform_array) #need to convert the platform array items into actual names, because the source is an image, not
    platforms = platform_array.map! do |platform|
      if platform.include?("win")
        platform = "Windows"
      elsif platform.include?("mac")
        platform = "Mac"
      elsif platform.include?("linux")
        platform = "Linux"
      elsif platform.include?("steamplay")
        platform = "Steam Play"
      elsif platform.include?("htcvive")
        platform = "HTC Vive"
      elsif platform.include?("oculusrift")
        platform = "Oculus Rift"
      else
        platform = nil
      end
    end
    platforms.select {|platform| platform != nil}
  end

  def self.scrape_game_page(game_url)
    doc = Nokogiri::HTML(open(game_url))
    about = doc.css(".game_description_snippet")
    tags = doc.css(".glance_tags a").map {|tag| tag.text}
    details = doc.css(".game_area_details_specs")
    game_attributes_hash = {
      :about => about.text.match(/\r|\n|\t/) ? about.text.delete("\t").delete("\r").delete("\n") : about.text,
      :tags => tags.map {|tag| tag.match(/\r|\n|\t/) ? tag.delete("\t").delete("\r").delete("\n") : tag },
      :details => details.map {|child| child.text} 
    }
  end

  def self.page_count(index_url)
    doc = Nokogiri::HTML(open(index_url))
    page_count = doc.css(".search_pagination_right").first.children[5].text.to_i
  end
end
