
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capybara/headless_chrome/version"

Gem::Specification.new do |spec|
  spec.name          = "capybara-headless_chrome"
  spec.version       = Capybara::HeadlessChrome::VERSION
  spec.authors       = ["Micah Geisel"]
  spec.email         = ["micah@botandrose.com"]

  spec.summary       = "A nice and tidy Capybara driver for headless Chrome"
  spec.description   = "A nice and tidy Capybara driver for headless Chrome. Even supports file downloads!"
  spec.homepage      = "https://github.com/botandrose/capybara-headless_chrome"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "chromedriver-helper", "1.2.0"
  spec.add_dependency "selenium-webdriver", "3.12.0" # 3.13.0 has breaking changes :(
  spec.add_dependency "capybara"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
