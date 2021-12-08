# set up with https://www.zagaja.com/2019/02/rspec-headless-chrome-capybara/
require 'selenium/webdriver'

# doesn't work. see https://github.com/mattheworiordan/capybara-screenshot#better-looking-html-screenshots
# Capybara.asset_host = 'http://localhost:3000'

RSpec.configure do |config|
  config.before(:each, type: :system) do
		driven_by(:rack_test)
	end

	config.before(:each, type: :system, js: true) do
		driven_by(:selenium_chrome_headless)
	end
end