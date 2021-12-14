require "empty_api_response"
require "story"

class StoriesController < ApplicationController
  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response

  def edit
    session[:story] ||= ::StoryDroid::Story.new.to_s
    @story = session[:story]
  end

  def update
    if pass_recaptcha?
      continued = ::StoryDroid::Story.continued_text(params[:story])
      if continued.length > ::StoryDroid::Story::MAX_LENGTH
        session_cookie_full
        return
      end
      session[:story] = continued
      redirect_to stories_edit_path(anchor: "footer"), status: "303"
    else
      redirect_to stories_edit_path,
        alert: "You failed the reCAPTCHA. Are you a bot? If not, try again!"
    end
  end

  private

  def empty_api_response(error)
    redirect_to stories_edit_path, alert: "#{error} Try again!"
  end

  def session_cookie_full
    redirect_to stories_edit_path,
      alert: "You've reached the story length limit! Soon I'll add a signup " \
             "option so that you can make a story even longer 🙂"
  end

  def pass_recaptcha?
    NewGoogleRecaptcha.human?(params[:new_recaptcha_token], "continue_story") ||
      Rails.env.test? # recaptcha always fails in test, so skip it.
  end
end
