require "bundler/setup"
require "capybara/headless_chrome"
require "capybara/rspec"
require "byebug"
require "./spec/support/test_app"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Capybara.app = TestApp.new
  Capybara.save_path = Pathname.new(__dir__).join("../tmp")
  Capybara.server = :webrick
end

