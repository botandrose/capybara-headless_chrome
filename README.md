# Capybara::HeadlessChrome
[![Build Status](https://travis-ci.org/botandrose/capybara-headless_chrome.svg?branch=master)](https://travis-ci.org/botandrose/capybara-headless_chrome)

A nice and tidy Capybara driver for headless Chrome. Even supports file downloads!

## Usage

### Capybara Setup

Just `require "capybara/headless_chrome"` somewhere in your test setup. This will register the `:chrome` driver, and make it  Capybara's default.

### Working with Downloaded Files

The Capybara session is extended with a single `#downloads` method that provides access to files downloaded during the session.

```ruby
page.click_link "Download Report"
page.downloads.filenames # => ["report.csv"]
page.downloads["report.csv"] # => #<File:report.csv>
```

Note that the `#[]` method is wrapped with Capybara's synchronize, so it will keep trying to find the file for up to `Capybara.default_max_wait_time` seconds.

Be sure to run `page.downloads.reset` at the beginning of every test run to empty the downloaded files list.

If you're using Cucumber, you can `require "capybara/headless_chrome/cucumber"` somewhere in your cucumber configuration to set this up for you.

## Installation

Add this to your application's Gemfile:

```ruby
group :test do
  gem 'capybara-headless_chrome'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-headless_chrome

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/botandrose/capybara-headless_chrome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
