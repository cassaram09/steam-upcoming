require_relative "scraper.rb"
require_relative "game.rb"
require 'nokogiri'
require 'colorize'

class SteamUpcoming::CLI
  base_url = "http://store.steampowered.com/search/?filter=comingsoon"

  def run
    make_games
    add_attributes_to_games
    list
  end

  def make_games
    game_array = Scraper.scrape_index_page(base_url)
    Game.create_from_collection(game_array)
  end

  def add_attributes_to_games
    Game.all.each do |game|
      attributes = Scraper.scrape_game_page(game.url)
      game.add_student_attributes(attributes)
    end
  end

  def list
    puts ""
    puts "************* Upcoming Games on the Steam Network *************"
    puts ""

  end

  def list_game
  end

  def display_games
    Game.all.each do |game|
      puts "#{student.name.upcase}".colorize(:blue)
      puts "  location:".colorize(:light_blue) + " #{student.location}"
      puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
      puts "  bio:".colorize(:light_blue) + " #{student.bio}"
      puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
      puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
      puts "  github:".colorize(:light_blue) + " #{student.github}"
      puts "  blog:".colorize(:light_blue) + " #{student.blog}"
      puts "----------------------".colorize(:green)
    end
  end
end

SteamUpcoming::CLI.new.run
