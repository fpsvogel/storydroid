require "rails_helper"

RSpec.describe "API-querying story page", type: :system do
  describe "story form" do
    it "has a default start to the story" do
      visit root_path
      expect(find('textarea').text.length).to be > 0
    end

    it "continues the story when submitted" do
      visit root_path
      default_story_length = find('textarea').text.length
      find('input[type="submit"]').click
      expect(find('textarea').text.length).to be > default_story_length
    end
  end
end