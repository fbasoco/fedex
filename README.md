# Fedex

Fedex test Rates Web service

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fedex'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fedex


## Usage

Add Credentials and query params:
```ruby
    credentials = {
        user_credential: {
          key: "bkjIgUhxdghtLw9L",
          password: "6p8oOccHmDwuJZCyJs44wQ0Iw"
        },
        user_details: {
          accoun_number: "510087720",
          meter_number: "119238439"
        }
      }

    quote_params = {
        address_from: {
            zip: "64000",
            country: "MX"
        },
        address_to: {
            zip: "64000",
            country: "MX"
        },
        parcel: {
            length: 25.0,
            width: 28.0,
            height: 46.0,
            distance_unit: "cm",
            weight: 6.5,
            mass_unit: "kg"
        }
    }

    rates = Fedex::Rates.get(credentials, quote_params)
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fbasoco/fedex.
