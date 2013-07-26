class Scraper
  class RateLimitReached < StandardError; end

  attr_accessor :opts, :fetched, :logger

  def initialize opts={}
    self.opts = opts
    self.fetched = 0
  end

  def scrape
    gists = GITHUB.gists.list(:public, self.opts)
    process(gists)
    while gists.size != 0 && gists.send(:page_iterator).next_page != -1
      sleep_if_needed gists.headers
      gists = next_page(gists)
      process(gists)
    end
    logger.debug "Fetched: #{self.fetched}"
    gists
  end

  private


  def logger
    @logger ||= Rails.logger
  end


  def sleep_if_needed headers
    rem = headers.ratelimit_remaining.to_i
    raise RateLimitReached if rem == 1
  end


  def process gists
    self.fetched += gists.size
    gists.map do |gist_data|
      Gist.create_from_github gist_data
    end
  end


  def next_page(gists)
    n ||= 0
    page = gists.send(:page_iterator).next_page
    logger.debug "Next page: #{page+n}"
    gists.page(page+n)
  rescue Github::Error::InternalServerError => e
    logger.warn e.inspect
    n += 1
    retry
  end


  # def sleep_if_needed headers
  #   @backoff ||= 1
  #   rem = headers.ratelimit_remaining.to_i
  #
  #   loop do
  #     puts "Remaining: #{rem}"
  #     if rem < 30
  #       @backoff *= 2
  #       sleep @backoff
  #     else
  #       if @backoff != 1
  #         @backoff /= 2
  #         sleep @backoff
  #       end
  #       break
  #     end
  #     puts "refreshing limit"
  #     rem = GITHUB.ratelimit_remaining
  #   end
  # end
  #
  # def sleep n
  #   puts "Sleeping #{n}"
  #   Kernel.sleep n
  # end

end