RSpec.describe Capybara::HeadlessChrome do
  it "can download files", type: :feature do
    visit "/"
    click_link "Download document.pdf"
    actual = md5sum(page.downloads["document.pdf"].path)
    expected = md5sum("spec/support/document.pdf")
    expect(actual).to eq expected
  end

  def md5sum path
    `md5sum #{path} | cut -f1 -d' '`.chomp.tap do
      raise unless $?.success?
    end
  end
end

