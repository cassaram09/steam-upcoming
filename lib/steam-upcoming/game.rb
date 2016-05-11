# The SteamUpcoming::Game class is responsible for taking informatino scraped from the Steam website
# and creating new Game objects with attributes. 

class SteamUpcoming::Game
  attr_accessor :name, :release_date, :platforms, :url, :about, :tags, :details 

  @@all = []

  def initialize
    @@all << self
  end

  def self.create_pages(page_count) #Create the page urls
    i = 1
    pages = []
    while i <= page_count.to_i
      pages << "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=#{i}"
      i += 1
    end
    pages
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