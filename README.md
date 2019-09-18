# Trustdock

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trustdock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trustdock

## Usage

```
require "trustdock"

client = Trustdock::Client.new(API_KEY)

# Verifications
verification = client.create_verification
verification = client.verification(verification.id)

# Plan
client.update_plan(verification.id, { ids: [plan_id] })

params = {
  "id_document": {
    "type": "passport",
    "format": "image",
    "data": {
      "front": [
        base64_image
      ],
      "back": [
        base64_image
      ]
    }
  }
}

# Document
client.update_document(verification.id, plan_id, params)

params = {
  "name": "日本花子",
  "birth": "1975-06-01",
  "address": "三重県津市垂水2566番地",
  "gender": "female"
}

# Ccomparing Data
response = client.update_comparing_data(verification.id, params)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on BitBucket at https://bitbucket.org/hachidori_develop/trustdock/

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
