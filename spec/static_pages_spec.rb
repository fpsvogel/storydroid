require "rails_helper"

RSpec.describe "Basic API-querying homepage", type: :system do
  describe "story form" do
    it "has a text area" do
      visit root_path
      expect(page).to have_selector('textarea')
    end

    it "has a default pre-filled story" do
      visit root_path
      expect(find('textarea').text.length).to be > 0
    end

    it "has a submit button" do
      visit root_path
      expect(page).to have_selector('input[type="submit"]')
    end

    it "outputs more story" do
      visit root_path
      default_story_length = find('textarea').text.length
      find('input[type="submit"]').click
      expect(find('textarea').text.length).to be > default_story_length
    end
  end
end