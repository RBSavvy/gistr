
desc 'Pulls gists from GitHub'
task(:pull_from_github, :since) do |t, vars|
  if vars[:since] == 'scrape'
    timestamp = nil
  else
    timestamp =  vars[:since].try(:to_time) || Gist.latest_timestamp.iso8601
  end
  Scraper.new(since: timestamp).scrape
end

task :pull_from_github => :environment