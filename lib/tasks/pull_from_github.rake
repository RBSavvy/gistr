
desc 'Pulls latest gists from GitHub'
task(:latest_from_github, :since) do |t, vars|
  if vars[:since] == 'scrape'
    timestamp = nil
  else
    timestamp =  vars[:since].try(:to_time) || Gist.latest_timestamp.iso8601
  end
  Scraper.new(since: timestamp).scrape
end

task :latest_from_github => :environment

desc 'Pulls latest gists from GitHub'
task(:scrape_from_github, :page) do |t, vars|
  Scraper.new(page: vars[:page].try(:to_i) ).scrape
end

task :scrape_from_github => :environment