require "webdrivers"
require "capybara"
require "capybara/headless_chrome/downloads"

module Capybara
  module HeadlessChrome
    class Driver < Capybara::Selenium::Driver
      def initialize app, options={}
        super app, browser: :chrome, desired_capabilities: chrome_capabilities(options)
        configure_downloads
        fix_whitespace
      end

      def downloads
        @downloads ||= Downloads.new
      end

      def javascript_errors
        console_entries level: "SEVERE"
      end

      def javascript_warnings
        console_entries level: "WARNING"
      end

      private

      def console_entries level: nil
        browser.manage.logs.get(:browser)
          .select {|e| level ? e.level == level : true }
          .map(&:message)
          .select(&:present?)
          .to_a
      end

      def chrome_capabilities options
        ::Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: {
            args: options_to_arguments(default_chrome_arguments.merge(options)),
            prefs: chrome_preferences,
          }
        )
      end

      def options_to_arguments options
        options.map do |key, value|
          arg = key.to_s.gsub(/_/,'-')
          if [true, false].include?(value)
            arg if value
          elsif value.is_a?(Array)
            "#{arg}=#{value.join(",")}"
          else
            raise NotImplementedError.new(message: [key, value])
          end
        end.compact
      end

      def default_chrome_arguments
        {
          no_sandbox: true,
          headless: true,
          disable_infobars: true,
          disable_popup_blocking: true,
          disable_gpu: true,
          window_size: [1280,1024],
        }
      end

      def chrome_preferences
        {
          "download.default_directory": downloads.dir,
          "download.directory_upgrade": "true",
          "download.prompt_for_download": "false",
          "browser.set_download_behavior": "{ 'behavior': 'allow' }",
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

