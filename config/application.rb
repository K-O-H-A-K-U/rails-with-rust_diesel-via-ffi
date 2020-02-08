# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'sequel'
require 'memcache'

require './test.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsSample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
logger = Logger.new(STDOUT)
logger.level = Logger::INFO
DB = Sequel.postgres(
  user: ENV['DB_USERNAME'],
  password: ENV['DB_PASSWORD'],
  host: 'localhost',
  port: '5432',
  database: 'testdb',
  max_connections: 10,
  logger: logger
)

# Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :eager_each
Sequel::Model.plugin :caching, MemCache.new('localhost:11211')
Sequel::Plugins::Caching.configure(Sequel::Model, LruRedux::ThreadSafeCache.new(24.hour))
# Sequel::Model.plugin :tactical_eager_loading
# Sequel.default_timezone = :local
# Sequel.extension :pagination
