require "selenium/webdriver"
require "chromedriver/helper"
require "capybara"
require "capybara/headless_chrome/downloads"

module Capybara
  module HeadlessChrome
    class Driver < Capybara::Selenium::Driver
      def initialize app
        super(app, browser: :chrome, desired_capabilities: chrome_capabilities)
        configure_downloads
      end

      def downloads
        Downloads.new
      end

      private

      def chrome_capabilities
        ::Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: {
            args: chrome_arguments,
            prefs: chrome_preferences
          }
        )
      end

      def chrome_arguments
        [
          "no-sandbox",
          "headless",
          "disable-infobars",
          "disable-popup-blocking",
          "disable-gpu",
          "window-size=1280,1024",
        ]
      end

      def chrome_preferences
        {
          "download.default_directory" => Downloads.dir,
          "download.directory_upgrade": "true",
          "download.prompt_for_download": "false",
          "browser.set_download_behavior": "{ behavior: 'allow' }",
        }
      end

      def configure_downloads
        bridge = browser.send(:bridge)
        path = '/session/:session_id/chromium/send_command'
        path[':session_id'] = bridge.session_id

        bridge.http.call(:post,
          path,
          cmd: 'Page.setDownloadBehavior',
          params: {
            behavior: 'allow',
            downloadPath: Downloads.dir,
          }
        )
      end
    end
  end
end

