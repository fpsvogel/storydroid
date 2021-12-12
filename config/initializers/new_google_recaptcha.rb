if Object.const_defined?('NewGoogleRecaptcha')
  NewGoogleRecaptcha.setup do |config|
    config.site_key   = Rails.application.credentials.dig(:recaptcha, :site_key)
    config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
    config.minimum_score = 0.5
  end
end