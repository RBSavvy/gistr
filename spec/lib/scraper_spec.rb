require 'spec_helper'


describe Scraper, :vcr do

  describe '#initialize' do
    let(:scraper) {       Scraper.new(since: Time.now) }

    it 'takes options' do
      expect(scraper.opts[:since]).to be_present
    end

    it 'sets the fetched count' do
      expect(scraper.fetched).to be(0)
    end
  end


  describe '#scrape' do
    let (:scraper) { Scraper.new() }

    it 'fetches a page' do
      VCR.use_cassette 'scraper', record: :none do
        scraper.scrape
      end
    end

    it 'raises an error when ratelimit exceeded' do
      expect {
        VCR.use_cassette 'scraper_ratelimited', record: :none do
          scraper.scrape
        end
      }.to raise_error Scraper::RateLimitReached
    end

    it 'skips pages that throw errors from github' do
      expect {
        VCR.use_cassette 'scraper_error', record: :none do
          scraper.scrape
        end
      }.to_not raise_error
    end
  end


end