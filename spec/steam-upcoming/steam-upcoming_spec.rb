require 'spec_helper'

RSpec.describe SteamUpcoming::Game do
  let(:games){SteamUpcoming::Game}
  let(:scraper){SteamUpcoming::Scraper.new}

  describe SteamUpcoming::Scraper do # this information is outdated, need to fix
    let!(:game_index_array) {
      [{:name=> "Vertigo Demo", :release_date=> "April 29th", :platforms=> ["Windows"], :url=>"http://store.steampowered.com/app/465430/?snr=1_7_7_comingsoon_150_1"},
       {:name=> "Stealth Labyrinth", :release_Date=> "April 29th", :platforms=> ["Windows", "HTC Vive", "Oculus Rift"], :url=>"http://store.steampowered.com/app/450040/?snr=1_7_7_comingsoon_150_1"},
      ]}

    describe "#new" do
      it 'initializes a new instance' do
        expect(SteamUpcoming::Scraper.new).to be_a(SteamUpcoming::Scraper)
      end
    end

    describe "#scrape_index_page" do 
      it 'it scrapes the index page and produces an array of hashes, each representing a game' do
        index_url = "http://store.steampowered.com/search/?filter=comingsoon"
        scraped_games = SteamUpcoming::Scraper.scrape_index_page(index_url)
        expect(scraped_games).to be_a(Array)
        expect(scraped_games.first).to have_key(:name)
        expect(scraped_games.first).to have_key(:release_date)
        expect(scraped_games.first).to have_key(:platforms)
        expect(scraped_games.first).to have_key(:url)
      end
    end

    describe "#scrape_game_page" do
      it 'it scrapes the game page and produces a hash' do
        game_url = "http://store.steampowered.com/app/461970/?snr=1_7_7_comingsoon_150_1"
        scraped_games = SteamUpcoming::Scraper.scrape_game_page(game_url)
        expect(scraped_games).to be_a(Hash)
        expect(scraped_games).to have_key(:about)
        expect(scraped_games).to have_key(:tags)
        expect(scraped_games).to have_key(:details)
      end
    end

    describe "#get_page_number" do
      it 'it gets the number of pages from the home page' do
        index_url = "http://store.steampowered.com/search/?filter=comingsoon"
        pages = SteamUpcoming::Scraper.get_page_number(index_url)
        expect(pages).to be_a(Integer)
      end
    end
  end

  describe SteamUpcoming::Game do

    describe "#new" do

      let(:skyreach){SteamUpcoming::Game.new({:name => "Skyreach", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"})}
    
      it "takes in an argument of a hash and sets that new game's attributes using the key/value pairs of that hash." do 
        expect(skyreach.name).to eq("Skyreach")
        expect(skyreach.release_date).to eq("April 2016")
        expect(skyreach.platforms).to eq(["Windows, Mac"])
        expect(skyreach.url).to eq("http://www.google.com")
      end 

      it "adds that new student to the Student class' collection of all existing students, stored in the `@@all` class variable." do 
        expect(SteamUpcoming::Game.all.first.name).to eq("Skyreach")
      end
    end

    describe "#all" do
      let(:soldiers){SteamUpcoming::Game.new({:name => "Soldiers", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"})}

      it "returns a list of all games as an array" do
        expect(SteamUpcoming::Game.all).to be_an(Array)
        expect(SteamUpcoming::Game.all.first).to be_a(SteamUpcoming::Game)
      end
    end

    describe "#create_from_collection" do

      let(:game_hash_array){[
      {:name => "Zombies", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"},
      {:name => "Gravity", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"},
      {:name => "Soldiers", :release_date=> "April 2016", :platforms => ["Windows, Linux"], :url => "http://www.zombies.com"}         
      ]}


      it "creates new Game objects from an array of hashes" do
        SteamUpcoming::Game.create_from_collection(game_hash_array)
        expect(SteamUpcoming::Game.all.first.name).to eq("Skyreach")
      end
    end

    describe "#add_game_attributes" do
      let(:gravity){SteamUpcoming::Game.new({:name => "Gravity", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"})}

      let(:game_hash){{
      :about=> "Explore an ancient civilization lost in the clouds. Wind your way through floating mountains, hand carved columns, and relics of a time long passed. Collect crystals and time your play precisely to increase your score as you travel through the stunning environments of Skyreach.",
      :tags=>["Free to Play", "Indie", "Casual", "Racing"],
      :details=>["Single-player", "Steam Achievements", "Full controller support"]}
      }

      it "adds attributes to the game objects from hashes" do
        SteamUpcoming::Game.reset
        gravity.add_game_attributes(game_hash)
        expect(SteamUpcoming::Game.all.first.tags).to eq(["Free to Play", "Indie", "Casual", "Racing"])

      end
    end

    describe "#all" do
      let(:vilmonic){SteamUpcoming::Game.new({:name => "Vilmonic", :release_date=> "April 2016", :platforms => ["Windows, Mac"], :url => "http://www.google.com"})}
      it "lists all of the objects in the SteamUpcoming::Game class" do
        expect(SteamUpcoming::Game.all).not_to be_empty
        expect(SteamUpcoming::Game.all).to include(vilmonic)
      end
    end

  end


  describe SteamUpcoming::CLI do
    SteamUpcoming::Game.reset

    

    describe "#make_games" do
      it "makes games" do
        upcoming  = SteamUpcoming::CLI.new
        upcoming.make_games
      end
    end

    #describe "#add_attributes_to_games" do
    #  it "adds attributes to games" do
    #    upcoming = SteamUpcoming::CLI.new
    #    upcoming.add_attributes_to_games
    #  end
    #end

    describe "#list" do
      it "lists games in the terminal" do
        SteamUpcoming::Game.reset
        upcoming = SteamUpcoming::CLI.new
        upcoming.add_attributes_to_games
        upcoming.list
      end
    end

    describe "#list_games" do
    end

    describe "#run" do
      it "runs the program" do
        upcoming = SteamUpcoming::CLI.new.run
      end
    end

  end

end





