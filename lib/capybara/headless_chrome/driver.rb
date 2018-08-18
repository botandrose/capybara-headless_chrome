require "selenium/webdriver"
require "chromedriver/helper"
require "capybara"
require "capybara/headless_chrome/downloads"

module Capybara
  module HeadlessChrome
    class Driver < Capybara::Selenium::Driver
      def initialize app, args: []
        super(app, browser: :chrome, desired_capabilities: chrome_capabilities(args))
        configure_downloads
        fix_whitespace
      end

      def downloads
        @downloads ||= Downloads.new
      end

      private

      def chrome_capabilities args
        ::Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: {
            args: chrome_arguments + args,
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
          "download.default_directory" => downloads.dir,
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
            downloadPath: downloads.dir,
          }
        )
      end

      def fix_whitespace
        Capybara::Selenium::Node.prepend Module.new {
          def visible_text
            super
              .gsub(/[\u200b\u200e\u200f]/, '')
              .gsub(/[\ \n\f\t\v\u2028\u2029]+/, ' ')
              .gsub(/\A[[:space:]&&[^\u00a0]]+/, '')
              .gsub(/[[:space:]&&[^\u00a0]]+\z/, '')
              .tr("\u00a0", ' ')
          end
        }
      end
    end
  end
end

