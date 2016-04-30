require_relative "scraper.rb"
require_relative "game.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class SteamUpcoming::CLI
  BASE_URL = "http://store.steampowered.com/search/?filter=comingsoon#sort_by=&sort_order=0&filter=comingsoon&page=1"

  def run
    puts "Fetching latest games from the Steam Network...".colorize(:yellow)
    make_games(BASE_URL)
    start
  end

  def make_games(url)
    game_array = SteamUpcoming::Scraper.scrape_index_page(url)
    binding.pry
    SteamUpcoming::Game.create_from_collection(game_array)
  end

  def change_page #allow the users to select another page
    input = gets.chomp
    pages = SteamUpcoming::Game.create_pages(SteamUpcoming::Scraper.page_count(BASE_URL)) #generate list of pages
    new_url = pages[input.to_i-1]
    binding.pry
    make_games(new_url)
    list
  end

  def list_game(game)
    #binding.pry
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

  def list
    puts ""
    puts "//-------------- Upcoming Games on Steam --------------//".colorize(:yellow)
    puts ""
    SteamUpcoming::Game.all.each.with_index do |game, index|
      puts "#{index}. #{game.name}"
    end
    puts "" 
  end

  def start
    list
    input = nil
    while input != "exit"
      puts ""
      puts "Learn more about a game by typing a name or number.".colorize(:yellow)
      puts ""
      puts "Enter \'list\'' to list games.".colorize(:light_blue)
      puts "Enter \'exit\' to exit.".colorize(:light_blue)
      puts ""
      print " > "
      input = gets.chomp
      if input == "list"
        list
      elsif input.to_i == 0
        if game = SteamUpcoming::Game.find_by_name(input)
          list_game(game)
        elsif input == "exit"
          break
        elsif input == "change"
          change_page
        else
          puts "#{input}".colorize(:red).concat(" is not a valid command.")
        end
      elsif input.to_i > 0
        if game = SteamUpcoming::Game.find(input.to_i)
          list_game(game)
        else
          puts "#{input}".colorize(:red).concat(" is not a valid selection. Please enter a number between 1 and #{SteamUpcoming::Game.all.count}.")
        end
      end
    end
    puts "Shutting down...".colorize(:yellow)
  end
end



