require 'rails/generators/base'
require 'jive/webhook/compatibility'

module Jive
	class Webhook < ActiveRecord::Base
		class Generator < Rails::Generators::Base
			source_paths << File.join(File.dirname(__FILE__), 'templates')
		end
	end
end