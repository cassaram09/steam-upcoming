class SteamUpcoming::Game
  attr_accessor :name, :release_date, :platforms, :url, :about, :tags, :details 

  @@all = []

  def initialize(game_hash)
    game_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(games_hash_array)
    games_hash_array.each do |game|
      object = Game.new(game)
    end
  end

  def add_game_attributes(game_attributes_hash)
    game_attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end


end