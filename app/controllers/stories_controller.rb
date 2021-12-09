require "empty_api_response"
require "story"

class StoriesController < ApplicationController
  # TODO auto-growing textarea: https://gist.github.com/yunusemredilber/c0598e168ef643fa8e9876b78c447b91
  # TODO but ultimately, prompt to sign up for an account.

  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response
  # TODO why isn't this caught in create, if I remove the length check?
  # rescue_from ActionDispatch::Cookies::CookieOverflow, with: :session_cookie_full
  # also, if I go this route, I need to add ~200 chars of filler to
  # session[:story] near the end of create, then remove that filler in show.
  # otherwise the story is discarded in cases where it's slightly too long.

  MAX_STORY_LENGTH = 1700

  def show
    session[:story] ||= ::StoryDroid::Story.new.to_s
    @story = session[:story]
  end

  def create
    if params[:story].length > MAX_STORY_LENGTH
      session[:story] = params[:story][0..MAX_STORY_LENGTH]
      session_cookie_full
      return
    end
    session[:story] = ::StoryDroid::Story.continued_text(params[:story])
    redirect_to stories_show_path
  end

  private

  def empty_api_response(error)
    redirect_to stories_show_path, alert: "#{error} Try again!"
  end

  def session_cookie_full
    redirect_to stories_show_path,
      alert: "You've reached the story length limit! Soon I'll add a signup " \
             " option so that you can make a story even longer 🙂"
  end
end
