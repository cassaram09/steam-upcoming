# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative './lib/steam-upcoming/version'

Gem::Specification.new do |spec|
  spec.name          = "steam-upcoming"
  spec.version       = SteamUpcoming::VERSION
  spec.authors       = ["Matt Cassara"]
  spec.email         = ["cassaram09@gmail.com"]

  spec.summary       = "This gem collects a list of upcoming games from the Steam Network via scraping."
  spec.description   = ""
  spec.homepage      = "http://rubygems.org/gems/steam-upcoming"
  spec.license       = "MIT"
  spec.files         = ["lib/steam-upcoming.rb", "lib/steam-upcoming/cli.rb", "lib/steam-upcoming/scraper.rb", "lib/steam-upcoming/game.rb", "config/environment.rb"]
  spec.bindir        = "bin"
  spec.executables   << 'steam-upcoming'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri", '~> 0'
  spec.add_development_dependency "colorize", '~> 0'
  spec.add_development_dependency "pry", '~> 0'
end
