require "fileutils"
require "capybara"

module Capybara
  module HeadlessChrome
    class Downloads
      class NotFound < Capybara::ExpectationNotMet; end

      def dir
        pathname.to_s
      end

      def reset
        FileUtils.rm_rf(dir)
        FileUtils.mkdir_p(dir)
      end

      def filenames
        pathname.entries.reject(&:directory?).map(&:to_s)
      end

      def [] filename
        Capybara.current_session.document.synchronize do
          begin
            File.open(pathname.join(filename))
          rescue Errno::ENOENT
            raise NotFound.new("Couldn't find #{filename} in #{filenames}")
          end
        end
      end

      private

      def pathname
        @pathname ||= Capybara.save_path.join(unique_id, "downloads")
      end

      def unique_id
        Time.now.strftime('%s%L')
      end
    end
  end
end

