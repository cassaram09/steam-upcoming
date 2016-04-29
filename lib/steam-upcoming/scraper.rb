require 'pry'

class SteamUpcoming::Scraper
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    game_array = []
    binding.pry
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
    binding.pry
  end

  def self.scrape_game_page(game_url)
  end

  def self.get_page_list(index_url)
  end

  def self.get_sorting_options(index_url)
  end

  def self.gather_platforms(parent)
    platforms = parent.children.map do |platform|
      platform == 0 || platform == nil ? next : platform.attr('class')
    end
    platforms.select {|platform| platform != nil}
  end

  def self.convert_platforms(platform_array)
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
  

end
