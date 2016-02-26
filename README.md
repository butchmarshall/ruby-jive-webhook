[![Gem Version](https://badge.fury.io/rb/jive-webhook.svg)](http://badge.fury.io/rb/jive-webhook)
[![Build Status](https://travis-ci.org/butchmarshall/ruby-jive-webhook.svg?branch=master)](https://travis-ci.org/butchmarshall/ruby-jive-webhook)

# Jive::Webhook

An implemention of Jives Webhooks using ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jive-webhook'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jive-webhook

then run

```ruby
rails generate jive:webhook:active_record
```

## Usage

To the ActiveRecord model:

```ruby
Jive::Webhook.new(...)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/butchmarshall/ruby-jive-webhook.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

