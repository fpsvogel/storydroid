require "empty_api_response"
require "story"

class StoriesController < ApplicationController
  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response
  # TODO if I remove the length check, why isn't this caught in create?
  # rescue_from ActionDispatch::Cookies::CookieOverflow, with: :session_cookie_full
  # also, if I take this approach, I need to add ~200 chars of filler to
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
    redirect_to stories_show_path(anchor: "footer")
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
