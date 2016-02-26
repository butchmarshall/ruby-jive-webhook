require 'logger'
require 'rspec'
require 'factory_girl'

require 'jive/webhook'

require 'database_cleaner'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

# Trigger AR to initialize
ActiveRecord::Base

#ActiveRecord::Base.logger = Logger.new(STDOUT)

module Rails
  def self.root
    '.'
  end
end

# Add this directory so the ActiveSupport autoloading works
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

if RUBY_PLATFORM == 'java'
	ActiveRecord::Base.establish_connection :adapter => 'jdbcsqlite3', :database => ':memory:'
else
	ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
end

#ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
ActiveRecord::Migration.verbose = false

require "generators/jive/add_on/templates/migration_0.1.0"
require "generators/jive/oauth_token/templates/migration_0.1.0"
require "generators/jive/webhook/templates/migration_0.1.0"

ActiveRecord::Schema.define do
	AddJiveAddOns010Migration.up
	AddJiveOauthTokens010Migration.up
	AddJiveWebhooks010Migration.up
end

RSpec.configure do |config|
	config.include FactoryGirl::Syntax::Methods
	config.after(:each) do
	end

	config.before(:suite) do
		DatabaseCleaner.strategy = :transaction
		DatabaseCleaner.clean_with(:truncation)
	end

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
end