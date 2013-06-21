require File.expand_path('../config/application', __FILE__)
require 'rspec/core/rake_task'

Gistr::Application.load_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color'
end
task :default => :spec