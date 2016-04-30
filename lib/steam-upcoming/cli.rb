require_relative "scraper.rb"
require_relative "game.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class SteamUpcoming::CLI
  BASE_URL = "http://store.steampowered.com/search/?filter=comingsoon"

  def run
    puts "Fetching latest games from the Steam Network..."
    make_games
    add_attributes_to_games
    start
  end

  def make_games
    game_array = SteamUpcoming::Scraper.scrape_index_page(BASE_URL)
    SteamUpcoming::Game.create_from_collection(game_array)
  end

  def add_attributes_to_games
    SteamUpcoming::Game.all.each do |game|
      attributes = SteamUpcoming::Scraper.scrape_game_page(game.url)
      game.add_game_attributes(attributes)
    end
  end

  def list_game(game)
    puts ""
    puts "//-------------- #{game.name} --------------//"
    puts ""
    puts game.about
    puts ""
    puts "Tags:"
    game.tags.each {|tag| puts " - #{tag}"}
    puts ""
    puts "Details:"
    game.details.each {|detail| puts " - #{detail}"}
    puts ""
    puts "Release Date:"
    puts " - #{game.release_date}" 
    puts ""
    puts "Platforms:"
    game.platforms.each {|platform| puts " - #{platform}"}
    puts ""
  end

  def list
    puts ""
    puts "************* Upcoming Games on the Steam Network *************"
    puts ""
    SteamUpcoming::Game.all.each.with_index(1) do |game, index|
      puts "#{index}. #{game.name}"
    end
    puts "" 
  end

  def start
    list
    input = nil
    while input != "exit"
      puts ""
      puts "What game would you more information on, by name or number?"
      puts ""
      puts "Enter list to see the games again."
      puts "Enter exit to end the program."
      puts ""
      print "please make a selection: > "
      input = gets.chomp
      if input == "list"
        list
      elsif input.to_i > 0
        if game = SteamUpcoming::Game.find(input.to_i)
          list_game(game)
        end
      elsif 
        nil
      end
    end
    puts "Goodbye!"
  end
end



