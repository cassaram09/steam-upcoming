class SteamUpcoming::CLI
  attr_accessor :url

  BASE_URL = "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=1"


  def initialize 
    @url = "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=1"
  end

  def run #run the program
    puts "\nFetching latest games from the Steam Network...".colorize(:yellow)
    make_games(BASE_URL)
    pages
    start
  end

  def make_games(url) #creates the list of games from the URL
    game_array = SteamUpcoming::Scraper.scrape_index_page(url)
    SteamUpcoming::Game.create_from_collection(game_array)
  end

  def pages #generate list of pages
    pages = SteamUpcoming::Game.create_pages(SteamUpcoming::Scraper.page_count(BASE_URL)) 
  end

  def change_page #allow the users to select another page
    print "Enter a page number > "
    input = gets.chomp.strip
    if @url = pages[input.to_i-1]
      SteamUpcoming::Game.reset
      make_games(@url)
      list
    else
      puts "#{input}".concat(" is not a valid page number. Please enter a number between 1 and #{pages.count}.").colorize(:red)
    end
  end

  def list_game(game) #list a game's details
    attributes = SteamUpcoming::Scraper.scrape_game_page(game.url)
    game.add_game_attributes(attributes)
    puts "\n//-------------- #{game.name} --------------//\n".colorize(:yellow)
    puts "About #{game.name}".colorize(:light_blue)
    puts game.about
    puts "\nTags:".colorize(:light_blue)
    game.tags.each {|tag| puts " - #{tag}"}
    puts "\nDetails:".colorize(:light_blue)
    game.details.each {|detail| puts " - #{detail}"}
    puts "\nRelease Date:".colorize(:light_blue)
    puts " - #{game.release_date}" 
    puts "\nPlatforms:".colorize(:light_blue)
    game.platforms.each {|platform| puts " - #{platform}"}
    puts ""
  end

  def list #list the games
    puts "\n//-------------- Upcoming Games on Steam --------------//\n".colorize(:yellow)
    SteamUpcoming::Game.all.each.with_index do |game, index|
      puts "#{index+1}. #{game.name}"
    end
    puts "\nPage #{current_page} of #{pages.count}".colorize(:yellow)
  end

  def current_page
    url = @url[-2,2]
    array = url.split("").map {|x| x.to_i}
    array[0] == 0 ? current_page = array[0] + array[1] : current_page = "#{array[0]}".concat("#{array[1]}")
  end

  def start #start the program loop
    list
    input = nil
    while input != "exit"
      puts "\nLearn more about a game by typing a name or number.\n".colorize(:yellow)
      puts "Enter \'list\'' to list games.".colorize(:light_blue)
      puts "Enter \'exit\' to exit.".colorize(:light_blue)
      puts "Enter \'page\' to switch pages.".colorize(:light_blue)
      print "\n > "
      input = gets.chomp.strip
      if input == "list"
        list
      elsif input.to_i == 0 #if input is a name
        if game = SteamUpcoming::Game.find_by_name(input)
          list_game(game)
        elsif input == "exit"
          break
        elsif input == "page"
          change_page
        else
          puts "\'#{input}\'".concat(" is not a valid title.").colorize(:red)
        end
      elsif input.to_i > 0 #if a number, look up the number
        if game = SteamUpcoming::Game.find(input.to_i)
          list_game(game)
        else
          puts "\'#{input}\'".concat(" is not a valid number. Please enter a number between 1 and #{SteamUpcoming::Game.all.count}.").colorize(:red)
        end
      end
    end
    puts "\nShutting down...\n".colorize(:red)
  end
end
