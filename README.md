# ActiveRecord::ObscuredId

`activerecord-obscuredid` is a gem that provides a way to encode and decode model IDs into Base32-obscured strings, making it easy to obscure the model IDs when exposing them in URLs or emails, for example.

## Installation
Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add activerecord-obscuredid
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
$ gem install activerecord-obscuredid
```

## Configuration

By default, the gem uses example.com as the domain for generating obscured email addresses. You can configure this to use a custom domain:

```ruby
# config/initializers/obscured_id.rb
ActiveRecord::ObscuredId.configure do |config|
  config.domain = 'yourdomain.com'

  # if you change your domain, and still need records to be findable by the old domain name
  config.old_domains = ['yourolddomain.com']
end
```

## Usage

For Rails users, the ActiveRecord::ObscuredId module is already included in ActiveRecord::Base by default, so there’s no need to include it again manually. The gem automatically extends ActiveRecord models with the obscured ID functionality.

```ruby
class User < ApplicationRecord
  # The module is already included, so you can use obscured_id related methods directly.
end
```

### Using with Non-Rails Models

If you’re not using Rails, or if your models don’t extend from ActiveRecord::Base, you can still use the ActiveRecord::ObscuredId module. To do so, include the module in your model and ensure your model has the following methods:
  - An id attribute or method.
  - A find method that accepts an id as an argument.
  - A find_by method that accepts an id: keyword argument.

Here’s an example of a model that satisfies these requirements:

```ruby
class User
  include ActiveRecord::ObscuredId

  attr_accessor :id

  # Method to find a record by its ID
  def self.find(id)
    # Implementation to find a record by its ID
  end

  # Method to find a record using an ID keyword argument
  def self.find_by(id:)
    # Implementation to find a record using a keyword argument
  end
end
```

The gem provides a way to encode the ID of a record into a Base32-obscured string, as well as decode it back:

```ruby
# Generating an Obscured ID
user = User.find(7371)
user.obscured_id # => "g4ztomi" (an example Base32-encoded version of the ID)

# Find by Obscured ID
User.find_obscured('g4ztomi') # => <User id: 7371, ...>
User.find_obscured!('g4ztomi') # Raises ActiveRecord::RecordNotFound if no user is found.

# Generate an Obscured Email Address
user.obscured_email_address # => "g4ztomi@users.yourdomain.com"

# Find by Obscured Email Address
User.from_obscured_email_address("g4ztomi@users.yourdomain.com") # => <User id: 7371, ...>
```

## Development

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes, add tests for them.
4. Ensure the tests and linter pass
5. Open a pull request with a detailed description of your changes.

### Setting up

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Running the tests and linter

Minitest is used for unit tests. Rubocop is used to enforce the ruby style.

To run the complete set of tests and linter run the following:

```bash
$ bundle install
$ bundle exec rake test
$ bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darthrighteous/activerecord-obscuredid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/darthrighteous/activerecord-obscuredid/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

