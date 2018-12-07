require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'watirspec/rake_tasks'
WatirSpec::RakeTasks.new

desc 'Run specs and watirspecs'
task default: %i[spec watirspec:run]

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end
