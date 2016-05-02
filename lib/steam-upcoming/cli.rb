class SteamUpcoming::CLI
  BASE_URL = "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=1"
  
  def run #run the program
    puts "Fetching latest games from the Steam Network...".colorize(:yellow)
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

  def page?(input=nil) #calculates the page the user is on
    if input != nil
      puts "you are on page #{input}"
    else
      puts "you are on main page."
    end
  end

  def change_page #allow the users to select another page
    print " Enter a page number > "
    input = gets.chomp.strip
    if new_url = pages[input.to_i-1]
      SteamUpcoming::Game.reset
      make_games(new_url)
      list
    else
      puts "\n#{input}".colorize(:red).concat(" is not a valid page number.")
    end
  end

  def list_game(game) #list a game's details
    attributes = SteamUpcoming::Scraper.scrape_game_page(game.url)
    game.add_game_attributes(attributes)
    puts ""
    puts "//-------------- #{game.name} --------------//".colorize(:yellow)
    puts ""
    puts "About #{game.name}".colorize(:light_blue)
    puts game.about
    puts ""
    puts "Tags:".colorize(:light_blue)
    game.tags.each {|tag| puts " - #{tag}"}
    puts ""
    puts "Details:".colorize(:light_blue)
    game.details.each {|detail| puts " - #{detail}"}
    puts ""
    puts "Release Date:".colorize(:light_blue)
    puts " - #{game.release_date}" 
    puts ""
    puts "Platforms:".colorize(:light_blue)
    game.platforms.each {|platform| puts " - #{platform}"}
    puts ""
  end

  def list #list the games
    puts ""
    puts "//-------------- Upcoming Games on Steam --------------//".colorize(:yellow)
    puts ""
    SteamUpcoming::Game.all.each.with_index do |game, index|
      puts "#{index+1}. #{game.name}"
    end
    puts "" 
    puts "#{pages.count} pages available.".colorize(:yellow)
    puts ""
    puts "#{}"
  end

  def start #start the program loop
    list
    input = nil
    while input != "exit"
      puts ""
      puts "Learn more about a game by typing a name or number.".colorize(:yellow)
      puts ""
      puts "Enter \'list\'' to list games.".colorize(:light_blue)
      puts "Enter \'exit\' to exit.".colorize(:light_blue)
      puts "Enter \'page\' to switch pages.".colorize(:light_blue)
      puts ""
      print " > "
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
          puts "#{input}".colorize(:red).concat(" is not a valid command.")
        end
      elsif input.to_i > 0 #if a number, look up the number
        if game = SteamUpcoming::Game.find(input.to_i)
          list_game(game)
        else
          puts "#{input}".colorize(:red).concat(" is not a valid selection. Please enter a number between 1 and #{SteamUpcoming::Game.all.count}.")
        end
      end
    end
    puts ""
    puts "Shutting down...".colorize(:red)
    puts ""
  end
end
