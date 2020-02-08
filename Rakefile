# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :db do
  require 'sequel'

  Sequel.extension :migration
  # DB = Sequel.connect(
  #   adapter: :postgres,
  #   user: ENV['DB_USERNAME'],
  #   password: ENV['DB_PASSWORD'],
  #   host: 'localhost',
  #   port: '5432',
  #   database: 'testdb',
  #   max_connections: 10,
  #   logger: Logger.new(STDOUT)
  # )

  desc 'execute migrate'
  task :s_migrate do
    Sequel::Migrator.run(DB, 'db/sequel/migrate')
  end

  desc 'reset'
  task :s_reset do
    Sequel::Migrator.run(DB, 'db/sequel/migrate', target: 0)
  end
end
