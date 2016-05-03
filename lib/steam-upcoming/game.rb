# The SteamUpcoming::Game class is responsible for taking informatino scraped from the Steam website
# and creating new Game objects with attributes. 

class SteamUpcoming::Game
  attr_accessor :name, :release_date, :platforms, :url, :about, :tags, :details 

  @@all = []

  def initialize(game_hash)
    game_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(games_hash_array) #create game objects from an array of hashes
    games_hash_array.each do |game|
      object = SteamUpcoming::Game.new(game)
    end
  end

  def add_game_attributes(game_attributes_hash) #add attributes to the Game object
    game_attributes_hash.each {|key, value| self.send(("#{key}="), value)} 
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