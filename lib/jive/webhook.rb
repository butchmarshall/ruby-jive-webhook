require "active_support"
require "active_support/dependencies"
require "active_record"

require "jive/add_on"
require "jive/oauth_token"

require "jive/webhook/version"
require "jive/webhook/class_methods"
require "jive/webhook/instance_methods"
require "jive/webhook/compatibility"
require "jive/webhook/configuration"

module Jive
	class Webhook < ::ActiveRecord::Base
	end
end

Jive::Webhook.send :include, Jive::Webhook::InstanceMethods
Jive::Webhook.send :extend, Jive::Webhook::ClassMethods