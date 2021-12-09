module StoryDroid
  class EmptyApiResponse < ActionController::BadRequest
    def initialize(msg = "OpenAI returned an empty response.")
      super
    end
  end
end
