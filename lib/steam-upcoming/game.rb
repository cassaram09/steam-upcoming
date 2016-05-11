# The SteamUpcoming::Game class is responsible for creating new Game objects with the information 
# collected from the SteamUpcoming::Scraper class.

class SteamUpcoming::Game
  attr_accessor :name, :release_date, :platforms, :url, :about, :tags, :details 

  @@all = []

  def initialize
    @@all << self
  end

  private
  def self.all #show all games
    @@all
  end

  private
  def self.reset #clear the list of games
    @@all.clear
  end

  def self.find(id) #find a game based on number
    self.all[id-1]
  end

  def self.find_by_name(name) #find a game based on name
    self.all.detect do |game|
      game.name.downcase == name
    end
  end

end