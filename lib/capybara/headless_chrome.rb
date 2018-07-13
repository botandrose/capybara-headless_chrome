require "capybara/headless_chrome/version"
require "capybara"
require "chromedriver/helper"
require "selenium/webdriver"

module Capybara
  module HeadlessChrome
    class DownloadNotFound < Capybara::ExpectationNotMet; end

    class Downloads
      class << self
        def setup
          FileUtils.rm_rf dir
          FileUtils.mkdir_p dir
        end

        def configure_driver driver
          bridge = driver.browser.send(:bridge)
          path = '/session/:session_id/chromium/send_command'
          path[':session_id'] = bridge.session_id

          bridge.http.call(:post,
            path,
            cmd: 'Page.setDownloadBehavior',
            params: {
              behavior: 'allow',
              downloadPath: dir,
            }
          )
        end

        def chrome_prefs
          {
            "download.default_directory" => dir,
            "download.directory_upgrade": "true",
            "download.prompt_for_download": "false",
            "browser.set_download_behavior": "{ behavior: 'allow' }",
          }
        end

        def dir
          pathname.to_s
        end

        def pathname
          Capybara.save_path.join("downloads")
        end
      end

      def filenames
        self.class.pathname.entries.reject(&:directory?).map(&:to_s)
      end

      def [] filename
        path = self.class.pathname.join(filename)
        Capybara.current_session.document.synchronize do
          begin
            File.open(path)
          rescue Errno::ENOENT
            raise DownloadNotFound.new("Couldn't find #{filename} in #{filenames}")
          end
        end
      end
    end
  end
end

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        "no-sandbox",
        "headless",
        "disable-infobars",
        "disable-popup-blocking",
        "disable-gpu",
        "window-size=1280,1024",
      ],
      prefs: {}.merge(Capybara::HeadlessChrome::Downloads.chrome_prefs),
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities).tap do |driver|
    Capybara::HeadlessChrome::Downloads.configure_driver driver
  end
end

Capybara.javascript_driver = :chrome
Capybara.default_driver = :chrome

Capybara::Session.class_eval do
  def downloads
    Capybara::HeadlessChrome::Downloads.new
  end
end
