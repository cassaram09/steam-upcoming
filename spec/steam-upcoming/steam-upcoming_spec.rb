require 'spec_helper'

RSpec.describe SteamUpcoming::Game do
  let(:games){SteamUpcoming::Game}
  let(:scraper){SteamUpcoming::Scraper.new}

  describe SteamUpcoming do
    it 'has a version number' do
      expect(SteamUpcoming::VERSION).not_to be nil
    end

    it 'does something useful' do
      expect(false).to eq(true)
    end
  end

  describe SteamUpcoming::Game do
    it 'initializes a new instance' do
      expect(SteamUpcoming::Game.new).to eq(true)
    end

    it ".all returns a list of all games as an array" do
      expect(games).to be_an(Array)
      expect(games.first).to be_a(SteamUpcoming::Game)
    end
  end

  describe SteamUpcoming::CLI do
    it 'initializes a new instance' do
      expect(SteamUpcoming::CLI.new).to eq(true)
    end
  end

  describe SteamUpcoming::Scraper do # this information is outdated, need to fix
    let!(:game_index_array) {
      [{:name=> "Vertigo Demo", :release_date=> "April 29th", :platforms=> ["Windows"], :url=>"http://store.steampowered.com/app/465430/?snr=1_7_7_comingsoon_150_1"},
       {:name=> "Stealth Labyrinth", :release_Date=> "April 29th", :platforms=> ["Windows", "HTC Vive", "Oculus Rift"], :url=>"http://store.steampowered.com/app/450040/?snr=1_7_7_comingsoon_150_1"},
      ]}

    it 'initializes a new instance' do
      expect(SteamUpcoming::Scraper.new).to be_a(SteamUpcoming::Scraper)
    end

    describe ".scrape_index_page" do 
      it 'it scrapes the index page and produces an array of hashes, each representing a game' do
        index_url = "http://store.steampowered.com/search/?filter=comingsoon"
        scraped_games = SteamUpcoming::Scraper.scrape_index_page(index_url)
        expect(scraped_games).to be_a(Array)
        expect(scraped_games.first).to have_key(:name)
        expect(scraped_games.first).to have_key(:release_date)
        #expect(scraped_games).to include(game_index_array[0], game_index_array[1])
      end
    end

    describe ".scrape_game_page" do
      it 'it scrapes the game page and produces a hash' do
        game_url = "http://store.steampowered.com/app/461970/?snr=1_7_7_comingsoon_150_1"
        scraped_games = SteamUpcoming::Scraper.scrape_game_page(game_url)
        expect(scraped_games).to be_a(Hash)
        expect(scraped_games).to have_key(:about)
        expect(scraped_games).to have_key(:tags)
        expect(scraped_games).to have_key(:details)
      end
    end

    describe ".get_page_number" do
      it 'it gets the number of pages from the home page' do
        index_url = "http://store.steampowered.com/search/?filter=comingsoon"
        pages = SteamUpcoming::Scraper.get_page_number(index_url)
        expect(pages).to eq(18)
      end
    end
  

  end
end

#expect(scraper.scrape_index_page).to include(is_a(Hash))