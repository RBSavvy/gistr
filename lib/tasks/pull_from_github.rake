
desc 'Pulls gists from GitHub'
task(:pull_from_github, :since) do |t, vars|
  timestamp = vars[:since].try(:to_time) || Gist.latest_timestamp
  Scraper.new(since: timestamp).scrape
end

task :pull_from_github => :environment