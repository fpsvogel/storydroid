require "empty_api_response"
require "story"

class StoriesController < ApplicationController
  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response

  def edit
    session[:story] ||= ::StoryDroid::Story.new.to_s
    @story = session[:story]
  end

  def update
    if params[:story].length > ::StoryDroid::Story::MAX_LENGTH
      session[:story] = params[:story][0..::StoryDroid::Story::MAX_LENGTH]
      session_cookie_full
    else
      session[:story] = ::StoryDroid::Story.continued_text(params[:story])
      redirect_to stories_edit_path(anchor: "footer"), status: "303"
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
end
