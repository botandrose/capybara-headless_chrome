RSpec.describe Capybara::HeadlessChrome do
  it "can load google" do
    Capybara.save_path = Pathname.new(__dir__).join("../../tmp")
    Capybara.current_session.visit "https://google.com"
  end
end
