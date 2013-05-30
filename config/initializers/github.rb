GITHUB = Github.new do |config|
  config.client_id     = Conf::Github[:client_id]
  config.client_secret = Conf::Github[:client_secret]
end