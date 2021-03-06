require 'pry'

class SteamUpcoming::CLI
  attr_accessor :url

  BASE_URL = "https://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=1"

  def initialize 
    @url = BASE_URL
  end

  def run #run the program
    puts "\nFetching latest games from the Steam Network...".colorize(:cyan)
    make_games(BASE_URL)
    pages
    start
  end

  def make_games(url) #creates the list of game objects from the chosen URL
    SteamUpcoming::Scraper.scrape_index_page(url)
  end

  def pages #generate list of page URLs as an array
    SteamUpcoming::Scraper.create_pages_with_urls(BASE_URL)
  end

  def number_of_results
    results = SteamUpcoming::Scraper.get_number_of_results(BASE_URL)
  end

  def change_page #allow the users to select another page
    print "Enter a page number > "
    input = gets.chomp
    @url = pages[input.to_i-1] #use the users input to select the corresponding page URL from the #pages array
    if  @url 
      SteamUpcoming::Game.reset #clear out the class variable so it can be populated with a new list of games
      make_games(@url) #create the games with the new chosen URL
      list
    else
      puts "#{input}".concat(" is not a valid page number. Please enter a number between 1 and #{pages.count}.").colorize(:red)
    end
  end

  def list_game(game) #list a game's details
    SteamUpcoming::Scraper.scrape_game_page(game.url)
    puts "\n//-------------- #{game.name} --------------//\n".colorize(:yellow)
    puts "About #{game.name}".colorize(:yellow)
    puts game.about
    puts "\nTags:".colorize(:yellow)
    game.tags.each {|tag| puts " - #{tag}"}
    puts "\nDetails:".colorize(:yellow)
    game.details.each {|detail| puts " - #{detail}"}
    puts "\nRelease Date:".colorize(:yellow)
    puts " - #{game.release_date}" 
    puts "\nPlatforms:".colorize(:yellow)
    game.platforms.each {|platform| puts " - #{platform}"}
    puts ""
  end

  def list #list the games
    puts "\n//-------------- Upcoming Games on Steam --------------//\n".colorize(:yellow)
    SteamUpcoming::Game.all.each.with_index do |game, index|
      puts "#{index+1}. #{game.name}"
    end
    puts "\nPage #{current_page} of #{pages.count}".colorize(:white)
    puts "\n#{number_of_results} results".colorize(:white)
  end

  def current_page
    url = @url[-2,2] #return the last two characters of the URL string
    array = url.split("").map {|x| x.to_i} #split the two characters into an array
    array[0] == 0 ? current_page = array[0] + array[1] : current_page = "#{array[0]}".concat("#{array[1]}").to_i
      #if the first element is a letter (it converts to 0), add it to the second element
      #if the both elements are numbers, concatenate them and return the new string
  end

  def start #start the program loop
    list
    input = nil
    while input != "exit" #loop user input until user types 'exit'
      puts "\nLearn more about a game by typing a name or number.\n".colorize(:yellow)
      puts "Enter \'list\'' to list games.".colorize(:yellow)
      puts "Enter \'exit\' to exit.".colorize(:yellow)
      puts "Enter \'page\' to switch pages.".colorize(:yellow)
      print "\n > "
      input = gets.chomp.strip
      if input == "list"
        list
      elsif input.to_i == 0 #if input is a name
        if game = SteamUpcoming::Game.find_by_name(input) #find game and list corresponding game
          list_game(game)
        elsif input == "exit" #exit the program
          break
        elsif input == "page" #commence the #change_page method
          change_page
        else
          puts "\'#{input}\'".concat(" is not a valid command.").colorize(:red)
        end
      elsif input.to_i > 0 #if a number
        if game = SteamUpcoming::Game.find(input.to_i) #find number and list corresponding game
          list_game(game)
        else
          puts "\'#{input}\'".concat(" is not a valid number. Please enter a number between 1 and #{SteamUpcoming::Game.all.count}.").colorize(:red)
        end
      end
    end
    puts "\nShutting down...\n".colorize(:red)
  end

end

