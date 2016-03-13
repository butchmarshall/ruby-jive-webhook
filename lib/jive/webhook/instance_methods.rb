module Jive
	class Webhook < ActiveRecord::Base
		module InstanceMethods
			def self.included(base)
				base.table_name = "jive_webhooks"
			end

			private
				def ensure_callback_from_configuration
					if self.callback.to_s.empty?
						self.callback = Jive::Webhook.configuration ? Jive::Webhook.configuration.callback : ""
					end
				end

				# Unregisters the webhook with Jive
				def unregister_webhook
					require "open-uri"
					require "net/http"
					require "openssl"

					return if self.add_on.nil? # Can't do it without a token!
					return if self.oauth_token.nil? # Can't do it without a token!

					uri = URI.parse("#{self.add_on.jive_url}/api/core/v3/webhooks/#{self.webhook_id}")
					http = Net::HTTP.new(uri.host, uri.port)
					http.use_ssl = true

					request = Net::HTTP::Delete.new(uri.request_uri)

					request["Content-Type"] = "application/json"
					request["Authorization"] = "Bearer #{self.oauth_token.access_token}"

					response = http.request(request)

					# Need 2XX status code
					if !response.code.to_i.between?(200, 299)
						errors[:base] << "#{request.inspect} => #{response.body}"
						return false
					end

					true
				end

				# Registers the webhook with Jive
				def register_webhook
					require "open-uri"
					require "net/http"
					require "openssl"

					uri = URI.parse("#{self.add_on.jive_url}/api/core/v3/webhooks")
					http = Net::HTTP.new(uri.host, uri.port)
					http.use_ssl = true
					#http.verify_mode = OpenSSL::SSL::VERIFY_NONE

					request = Net::HTTP::Post.new(uri.request_uri)

					request["Content-Type"] = "application/json"
					request["Authorization"] = "Bearer #{self.oauth_token.access_token}"

					body = {
						"callback" => self.callback,
						"object" => self.object,
					}
					body["events"] = self.events if !self.events.to_s.empty?

					request.body = body.to_json

					response = http.request(request)

					# Need 2XX status code
					if !response.code.to_i.between?(200, 299)
						errors[:base] << "#{request.inspect} => #{response.body}"
						return false
					end

					json_body = JSON.parse(response.body)

					self.webhook_id = json_body["id"]

					true
				end
		end
	end
end