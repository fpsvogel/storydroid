require "empty_api_response"

class StoriesController < ApplicationController
  # TODO auto-growing textarea: https://gist.github.com/yunusemredilber/c0598e168ef643fa8e9876b78c447b91
  # TODO rescue_from ActionDispatch::Cookies::CookieOverflow
  #      with alert: "The story is too big to fit in the session cookie."
  # TODO but ultimately, prompt to sign up for an account.

  rescue_from ::StoryDroid::EmptyApiResponse, with: :empty_api_response

  DEFAULT_STORY = "It was the year 2121. It was a post-apocalyptic world. " \
    "Zombies crowded around my house. One started pounding at my front door. " \
    "I huddled in the corner of my living room, too terrified to move. "
  RESPONSE_SIZE = 50
  RESPONSE_TEMPERATURE = 0.5

  def show
    @story = session[:story] || DEFAULT_STORY
  end

  def create
    response = ai_response(params[:story])
    session[:story] = params[:story] + response
    redirect_to stories_show_path
  end

  private

  def ai_response(prompt)
    api_key = Rails.application.credentials.dig(:open_ai, :api_key)
    client = OpenAI::Client.new(access_token: api_key)
    raw_resp = client.completions(engine: "davinci",
                                  parameters:
                                    { prompt: prompt,
                                      max_tokens: RESPONSE_SIZE,
                                      temperature: RESPONSE_TEMPERATURE })
                     .parsed_response["choices"]
    raw_resp = nil
    raise ::StoryDroid::EmptyApiResponse if raw_resp.nil?
    response = raw_resp.map { |c| c["text"] }.first
    clean_up(response)
  end

  def clean_up(response)
    response.gsub("\u00A0", " ") # non-breaking space
            .strip
            .gsub(/\s{2,}/, " ") + " "
  end

  def empty_api_response(error)
    redirect_to stories_show_path, alert: "#{error} Try again!"
  end
end
