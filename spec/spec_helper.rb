ENV["RAILS_ENV"] ||= "test"

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start('rails') do
  add_filter '.bundle'
  add_filter 'app/secrets'
end


require File.expand_path('../../config/environment', __FILE__)

RSpec.configure do |config|
  config.before(:each) do
    REDIS.flushdb
    Dir[Rails.root.join('spec/fixtures/**/*.rb')].each { |f| load f }
  end


end
