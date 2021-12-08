class StaticPagesController < ApplicationController
  DEFAULT_STORY = "It was a dark and stormy night. Zombies crowded around " \
    "my house. One of them started pounding at my front door. I huddled " \
    "in the corner of my living room, too terrified to move."

  def home
    @story = session[:story] || DEFAULT_STORY
  end
end
