require "generators/jive/webhook/webhook_generator"
require "generators/jive/webhook/next_migration_version"
require "rails/generators/migration"
require "rails/generators/active_record"

# Extend the HasDynamicColumnsGenerator so that it creates an AR migration
module Jive
	class Webhook < ActiveRecord::Base
		class ActiveRecordGenerator < ::Jive::Webhook::Generator
			include Rails::Generators::Migration
			extend NextMigrationVersion

			source_paths << File.join(File.dirname(__FILE__), "templates")

			def create_migration_file
				migration_template "migration_0.1.0.rb", "db/migrate/add_jive_webhooks_0_1_0_migration.rb"
			end

			def self.next_migration_number(dirname)
				::ActiveRecord::Generators::Base.next_migration_number dirname
			end
		end
	end
end