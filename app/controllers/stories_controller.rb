require "empty_api_response"
require "story"

class StoriesController < ApplicationController
  # TODO auto-growing textarea: https://gist.github.com/yunusemredilber/c0598e168ef643fa8e9876b78c447b91
  # TODO rescue_from ActionDispatch::Cookies::CookieOverflow
  #      with alert: "The story is too big to fit in the session cookie."
  # TODO but ultimately, prompt to sign up for an account.

  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response

  def show
    @story = (session[:story] ||= ::StoryDroid::Story.new.to_s)
  end

  def create
    session[:story] = ::StoryDroid::Story.continued_text(params[:story])
    redirect_to stories_show_path
  end

  private

  def empty_api_response(error)
    redirect_to stories_show_path, alert: "#{error} Try again!"
  end
end
