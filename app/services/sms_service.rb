class SmsService
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new(
      Rails.application.config.twilio.account_sid,
      Rails.application.config.twilio.auth_token
    )
  end

  # Send an SMS message to a phone number
  # @param phone_number [String] The recipient's phone number (e.g., "+1234567890")
  # @param message [String] The message content to send
  # @return [Twilio::REST::Api::V2010::AccountContext::MessageInstance] The message instance
  # @raise [SmsService::Error] If the message fails to send
  def send_message(phone_number:, message:)
    validate_phone_number!(phone_number)
    validate_message!(message)

    begin
      response = client.messages.create(
        from: Rails.application.config.twilio.from_phone,
        to: phone_number,
        body: message
      )

      Rails.logger.info "SMS sent successfully to #{phone_number}. SID: #{response.sid}"
      response
    rescue => e
      if e.is_a?(Twilio::REST::RestError)
        Rails.logger.error "Failed to send SMS to #{phone_number}: #{e.message}"
        raise Error, "Failed to send SMS: #{e.message}"
      else
        Rails.logger.error "Unexpected error sending SMS to #{phone_number}: #{e.message}"
        raise Error, "Unexpected error sending SMS: #{e.message}"
      end
    end
  end

  # Send an SMS message to a user (placeholder for future user model integration)
  # This method will be implemented when the User model is available
  # @param user [User] The user to send the message to
  # @param message [String] The message content to send
  # @return [Twilio::REST::Api::V2010::AccountContext::MessageInstance] The message instance
  def send_message_to_user(user:, message:)
    # TODO: Implement when User model is available
    # This will likely call: send_message(phone_number: user.phone_number, message: message)
    raise NotImplementedError, "User model integration not yet implemented"
  end

  private

  def validate_phone_number!(phone_number)
    unless phone_number.is_a?(String) && phone_number.match?(/^\+\d{10,15}$/)
      raise ArgumentError, "Phone number must be a string in E.164 format (e.g., '+1234567890')"
    end
  end

  def validate_message!(message)
    unless message.is_a?(String) && !message.strip.empty?
      raise ArgumentError, "Message must be a non-empty string"
    end

    if message.length > 1600
      raise ArgumentError, "Message cannot exceed 1600 characters"
    end
  end

  # Custom error class for SMS-related errors
  class Error < StandardError; end
end
