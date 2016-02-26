require 'spec_helper'

describe Jive::Webhook do
	# Setup add-on
	before(:each) do
		stub_request(:post, "https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d").
         with(:body => "clientId:2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i\nclientSecret:09da4b6f11102012b476a686fabb37a61240ba89477f0fec4d0f974b428dd141\njiveSignatureURL:https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d\njiveUrl:https://sandbox.jiveon.com\ntenantId:b22e3911-28ef-480c-ae3b-ca791ba86952\ntimestamp:2015-11-20T16:04:55.895+0000\n",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Jive-Mac'=>'0YqbK1nW+L+j3ppE7PHo3CvM/pNyHIDbNwYYvkKJGXU='}).                                                                                           
         to_return(:status => 200, :body => "", :headers => {})

		@add_on = ::Jive::AddOn.create({
			client_id: '2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i',
			tenant_id: 'b22e3911-28ef-480c-ae3b-ca791ba86952',
			jive_signature_url: 'https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d',
			client_secret: 'evaqjrbfyu70jlvnap8fhnj2h5mr4vus.s',
			jive_signature: '0YqbK1nW+L+j3ppE7PHo3CvM/pNyHIDbNwYYvkKJGXU=',
			jive_url: 'https://sandbox.jiveon.com',
			timestamp: '2015-11-20T16:04:55.895+0000',
		})

		@oauth_token = Jive::OauthToken.create(
			:scope => "uri:/api/jivelinks/v1/tiles/10543",
			:token_type => "bearer",
			:expires_in => "172799",
			:expires_at => "2016-02-12 00:41:26",
			:refresh_token => "iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r",
			:access_token => "a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t",
		)
	end

	it 'has a version number' do
		expect(Jive::Webhook::VERSION).not_to be nil
	end

	it 'should not save without oauth_token' do
		expect(Jive::Webhook.create.new_record?).to be true
	end

	describe '#callback' do
		it 'should not create without a callback' do
			webhook = Jive::Webhook.create(:oauth_token => @oauth_token, :add_on => @add_on, :events => "eventa", :object => "objectb")
			expect(webhook.new_record?).to be true
		end

		it 'should not create with default callback', :focus => true do
			Jive::Webhook.configure do |config|
				config.callback = "callbacke"
			end

			stub_request(:post, "https://sandbox.jiveon.com/api/core/v3/webhooks").
			 with(:body => "{\"events\":\"eventa\",\"callback\":\"callbacke\",\"object\":\"objectb\"}",
				  :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).                                                                                   
			 to_return(:status => 200, :body => "", :headers => {})

			webhook = Jive::Webhook.create(:oauth_token => @oauth_token, :add_on => @add_on, :events => "eventa", :object => "objectb")

			expect(webhook.new_record?).to be false
		end
	
		it 'should create' do
			Jive::Webhook.configure do |config|
				config.callback = "callbackc"
			end

			stub_request(:post, "https://sandbox.jiveon.com/api/core/v3/webhooks").
			 with(:body => "{\"events\":\"eventa\",\"callback\":\"callbackd\",\"object\":\"objectb\"}",
				  :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).                                                                                                                                               
			 to_return(:status => 200, :body => "", :headers => {})

			stub_request(:post, "https://sandbox.jiveon.com/api/core/v3/webhooks").
					with(:body => "{\"events\":\"eventa\",\"callback\":\"callbackc\",\"object\":\"objectb\"}",
						 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).                                                                                                                                               
					to_return(:status => 200, :body => "", :headers => {})

			webhook = Jive::Webhook.create(:oauth_token => @oauth_token, :add_on => @add_on, :events => "eventa", :object => "objectb")
			webhook = Jive::Webhook.create(:oauth_token => @oauth_token, :add_on => @add_on, :events => "eventa", :object => "objectb", :callback => "callbackc")
		end
	end
end
