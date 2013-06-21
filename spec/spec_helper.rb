ENV["RAILS_ENV"] ||= "test"

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails' do
  add_filter 'vendor'
  add_filter '.bundle'

  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Lib",         "lib"
  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/autorun'
