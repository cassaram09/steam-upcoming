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

  describe SteamUpcoming::Scraper do
     let!(:game_index_array) {[{:name=>"Joe Burgess", :location=>"New York, NY", :profile_url=>"http://127.0.0.1:4000/students/joe-burgess.html"},
                               {:name=>"Mathieu Balez", :location=>"New York, NY", :profile_url=>"http://127.0.0.1:4000/students/mathieu-balez.html"},
                               {:name=>"Diane Vu", :location=>"New York, NY", :profile_url=>"http://127.0.0.1:4000/students/diane-vu.html"}]}


    describe ".scrape_index_page" do
      it 'it scrapes the index page and produces an array of hashes, each representing a game' do
        expect(scraper.scrape_index_page).to include(is_a(Hash))
      end
    end

  end
end

#expect(scraper.scrape_index_page).to include(is_a(Hash))