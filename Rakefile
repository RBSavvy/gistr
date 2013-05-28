require File.expand_path('../config/application', __FILE__)
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color'
end
task :default => :spec


Gistr::Application.load_tasks



