module Jive
	class Webhook < ActiveRecord::Base
		module ClassMethods
			def self.extended(base)
				base.send(:attr_accessor, :configuration)
				base.belongs_to :add_on, :class_name => "Jive::AddOn", :foreign_key => :jive_add_on_id
				base.belongs_to :oauth_token, :class_name => "Jive::OauthToken", :foreign_key => :jive_oauth_token_id
				base.validates :add_on, presence: true
				base.validates :oauth_token, presence: true
				base.validates :callback, presence: true
				base.before_create :register_webhook
				base.before_destroy :unregister_webhook
				base.before_validation :ensure_callback_from_configuration
			end

			def configuration
				@configuration
			end

			def configure
				@configuration ||= Jive::Webhook::Configuration.new
				yield(@configuration)
			end
		end
	end
end