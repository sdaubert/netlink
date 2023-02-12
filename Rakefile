# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-t ~sudo'
end
RSpec::Core::RakeTask.new('spec:sudo') do |t|
  t.rspec_opts = '-t sudo'
end

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
  task default: %i[spec rubocop]
rescue LoadError
  task default: :spec
end

# rubocop:disable Lint/SuppressedException
begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files = ['lib/**/*.rb', '-', 'README.md', 'LICENSE.txt']
    t.options = %w[--no-private]
  end
rescue LoadError
end
# rubocop:enable Lint/SuppressedException
