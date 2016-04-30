require 'pry'


class SteamUpcoming::Game
  attr_accessor :name, :release_date, :platforms, :url, :about, :tags, :details 

  @@all = []

  def initialize(game_hash)
    game_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(games_hash_array)
    games_hash_array.each do |game|
      object = SteamUpcoming::Game.new(game)
    end
  end

  def add_game_attributes(game_attributes_hash)
    game_attributes_hash.each {|key, value| self.send(("#{key}="), value)} 
  end

  def self.create_pages(page_count)
    i = 1
    pages = []
    while i < page_count.to_i
      pages << "http://store.steampowered.com/search/?filter=comingsoon&sort_order=0&filter=comingsoon&page=#{i}"
      i += 1
    end
    pages
  end

  def self.all
    @@all
  end

  def self.reset 
    @@all.clear
  end

  def self.find(id)
    self.all[id-1]
  end

  def self.find_by_name(name)
    self.all.detect do |game|
      game.name.downcase == name
    end
  end

end

