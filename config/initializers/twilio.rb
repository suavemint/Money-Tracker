require 'twilio-ruby'

# Twilio configuration
Rails.application.configure do
  # Twilio credentials - use environment variables or Rails credentials
  config.twilio = ActiveSupport::OrderedOptions.new
  
  # Try environment variables first, fall back to Rails credentials
  config.twilio.account_sid = ENV.fetch('TWILIO_ACCOUNT_SID') do
    Rails.application.credentials.dig(:twilio, :account_sid)
  end
  
  config.twilio.auth_token = ENV.fetch('TWILIO_AUTH_TOKEN') do
    Rails.application.credentials.dig(:twilio, :auth_token)
  end
  
  config.twilio.from_phone = ENV.fetch('TWILIO_FROM_PHONE') do
    Rails.application.credentials.dig(:twilio, :from_phone)
  end
end