require "capybara"

module Capybara
  module HeadlessChrome
    class Downloads
      class NotFound < Capybara::ExpectationNotMet; end

      class << self
        def dir
          pathname.to_s
        end

        def pathname
          Capybara.save_path.join("downloads")
        end
      end

      def reset
        FileUtils.rm_rf self.class.dir
        FileUtils.mkdir_p self.class.dir
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
            raise NotFound.new("Couldn't find #{filename} in #{filenames}")
          end
        end
      end
    end
  end
end

