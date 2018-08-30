module Capybara
  module HeadlessChrome
    module SessionDSL
      def downloads
        driver.downloads
      end
      
      def javascript_errors
        driver.javascript_errors
      end

      def javascript_warnings
        driver.javascript_warnings
      end
    end
  end
end

