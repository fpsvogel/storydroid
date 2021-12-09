class StoriesController < ApplicationController
  DEFAULT_STORY = "It was the year 2121. It was a post-apocalyptic world. " \
    "Zombies crowded around my house. One started pounding at my front door. " \
    "I huddled in the corner of my living room, too terrified to move."

  def show
    @story = session[:story] || DEFAULT_STORY
  end

  def create
    # TODO call OpenAI API here, and add on the results to the story.
    temp_continuation = " And then they decided to go home."
    session[:story] = params[:story] + temp_continuation
    redirect_to root_path
  end
end
