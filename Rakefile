require File.expand_path('../config/application', __FILE__)

Gistr::Application.load_tasks

if Rails.env.development? || Rails.env.test?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--color'
  end
  task :default => :spec
end