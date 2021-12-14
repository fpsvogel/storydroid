module StoryDroid
  class Story
    MAX_LENGTH = 1700
    # MAX_LENGTH prevents the session cookie from overflowing. my first solution:
    # rescue_from ActionDispatch::Cookies::CookieOverflow, with: :session_cookie_full
    # but for some reason the exception wasn't caught.

    DEFAULT_TEXTS =
      {
        zombie: <<~STORY
          It was the year 2121. It was a post-apocalyptic world. Zombies crowded
          around my house. One started pounding at my front door. I huddled in
          the corner of my living room, too terrified to move.
        STORY
      }
    DEFAULT_CONFIG =
      {
        response_size: 50,
        response_temperature: 0.5,
        ai_level: { "development" => 1,
                    "test" => 1,
                    "production" => 4 }[Rails.env]
      }

    attr_reader :text, :response_size, :response_temperature, :ai_level
    alias_method :to_s, :text

    def initialize(text: nil, default_type: :zombie)
      @text = text || default_text(default_type)
      apply_default_settings
      @ai = client
    end

    def continued
      @text = @text + ai_response
      self
    end

    def self.continued_text(existing_text)
      new(text: existing_text).continued.text
    end

    private

    def default_text(type)
      DEFAULT_TEXTS[type].gsub("\n", " ")
    end

    def apply_default_settings
      DEFAULT_CONFIG.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end

    def client
      api_key = Rails.application.credentials.dig(:open_ai, :api_key)
      OpenAI::Client.new(access_token: api_key)
    end

    def ai_response
      loop do
        raw_resp = @ai.completions(engine: ai_engine,
                                    parameters:
                                      { prompt: text,
                                        max_tokens: response_size,
                                        temperature: response_temperature })
                        .parsed_response["choices"]
        raise ::StoryDroid::EmptyApiResponse if raw_resp.nil?
        response = raw_resp.map { |c| c["text"] }.first
        response = clean_up(response)
        return response unless dud_response?(response)
      end
    end

    def dud_response?(response)
      response.length < response_size
    end

    def ai_engine
      %w[ada babbage curie davinci][ai_level - 1]
    end

    def clean_up(response)
      response.gsub("\u00A0", " ") # non-breaking space
              .strip
              .gsub(/\s{2,}/, " ") + " "
    end
  end
end
