require "rails_helper"

RSpec.describe "API-querying story page", type: :system do
  describe "story form" do
    it "has a default start to the story" do
      visit stories_show_path
      expect(find('textarea').text.length).to be > 0
    end

    it "continues the story when submitted" do
      visit stories_show_path
      default_story_length = find('textarea').text.length
      find('input[type="submit"]').click
      expect(find('textarea').text.length).to be > default_story_length
    end

    it "shows a warning when the story is too long" do
      visit stories_show_path
      overly_long_story = "0123456789" * 200
      find('textarea').set(overly_long_story)
      find('input[type="submit"]').click
      expect(find('textarea').text.length).to be < overly_long_story.length
      expect(page).to have_selector('div.alert')
    end
  end
end