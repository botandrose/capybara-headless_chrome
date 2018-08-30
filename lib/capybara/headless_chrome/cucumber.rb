Before do
  page.downloads.reset
end

AfterStep do
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

