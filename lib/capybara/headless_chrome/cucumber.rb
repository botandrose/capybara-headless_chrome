Before do
  if page.driver.class.name == "Capybara::HeadlessChrome::Driver"
    page.downloads.reset
  end
end

AfterStep do
  if page.driver.class.name == "Capybara::HeadlessChrome::Driver"
    aggregate_failures 'javascript errors' do
      page.javascript_errors.each do |error|
        fail error
      end
    end

    page.javascript_warnings.each do |warning|
      STDERR.puts 'WARN: javascript warning'
      STDERR.puts warning
    end
  end
end

