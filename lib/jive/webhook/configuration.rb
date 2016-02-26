module Jive
	class Webhook < ActiveRecord::Base
		class Configuration
			attr_accessor :callback

			def initialize
				@callback = nil
			end
		end
	end	
end