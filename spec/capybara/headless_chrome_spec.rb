RSpec.describe Capybara::HeadlessChrome do
  it "can download files", type: :feature do
    visit "/"
    click_link "Download document.pdf"
    actual = crc32(page.downloads["document.pdf"].path)
    expected = crc32("spec/support/document.pdf")
    expect(actual).to eq expected
  end

  def crc32 path
    `crc32 #{path}`.chomp.tap do
      raise unless $?.success?
    end
  end
end

