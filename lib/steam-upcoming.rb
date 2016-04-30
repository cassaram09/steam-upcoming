require 'open-uri'
require 'pry'
require 'nokogiri'
require_relative "steam-upcoming/version.rb"
require_relative "steam-upcoming/cli.rb"
require_relative "steam-upcoming/game.rb"
require_relative "steam-upcoming/scraper.rb"

module SteamUpcoming
end

upcoming = SteamUpcoming::CLI.new.run
