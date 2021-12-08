class StoriesController < ApplicationController
  def create
    # TODO call OpenAI API here, and add on the results to the story.
    temp_continuation = " And then they decided to go home."
    session[:story] = params[:story] + temp_continuation
    redirect_to root_path
  end
end
