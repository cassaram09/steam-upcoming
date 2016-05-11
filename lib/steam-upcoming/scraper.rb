# The SteamUpcoming::Scraper class is responsible for scraping information off of the target webpage
# and creating the SteamUpcoming::Game objects in the process. 
#
# When the program is first run, ::Scraper will only collect information from the index page. When a game
# is selected by the user, Scraper will then scrape the remaining attributes from the game page, add them 
# to the selected ::Game object, and then output the information to the terminal.  

class SteamUpcoming::Scraper
  def self.scrape_index_page(index_url) #scrape the page and create game objects with scraped properties
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".search_result_row").each do |game|
      game_object = SteamUpcoming::Game.new
      game_object.name = game.css(".title").text
      game_object.release_date = game.css(".search_released").text  
      game_object.platforms = gather_and_convert_platforms(game.css(".search_name p")) 
      game_object.url = game.first[1]
    end
  end

  def self.gather_and_convert_platforms(parent) #gather platforms and convert the items into actual names, because the source is an image, not text
    platforms = parent.children.map {|platform| platform.attr('class')}
    platforms.delete_if {|platform| platform == nil}
    platforms.map! do |platform|
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
        next
      end
    end
  end

  def self.scrape_game_page(game_url) #scrape the page and create a hash of game attributes
    doc = Nokogiri::HTML(open(game_url))
    about = doc.css(".game_area_description")
    tags = doc.css(".glance_tags a").map {|tag| tag.text}
    details = doc.css(".game_area_details_specs")
    SteamUpcoming::Game.all.each do |game|
       if game_url == game.url
        game.about = about.text.match(/\r|\n|\t/) ? about.text.delete("\t").delete("\r").delete("\n") : about.text
        game.tags = tags.map {|tag| tag.match(/\r|\n|\t/) ? tag.delete("\t").delete("\r").delete("\n") : tag }
        game.details = details.map {|child| child.text}
        return game
      end
    end
  end

  def self.create_pages_with_urls(index_url) #scrape the pages to get the total number of pages
    doc = Nokogiri::HTML(open(index_url))
    page_count = doc.css(".search_pagination_right").first.children[5].text.to_i
    i = 1
    pages = []
    while i <= page_count.to_i
      pages << "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=#{i}"
      i += 1
    end
    pages
  end
end
