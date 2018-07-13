require "capybara/headless_chrome/version"
require "capybara/headless_chrome/driver"
require "capybara/headless_chrome/session_dsl"

Capybara.register_driver :chrome do |app|
  Capybara::HeadlessChrome::Driver.new(app)
end

Capybara.default_driver = Capybara.javascript_driver = :chrome

Capybara::Session.include Capybara::HeadlessChrome::SessionDSL

