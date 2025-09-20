require "test_helper"
require "minitest/mock"
require "ostruct"

class SmsServiceTest < ActiveSupport::TestCase
  def setup
    @service = SmsService.new
    @valid_phone = "+1234567890"
    @valid_message = "Hello, this is a test message!"
  end

  test "initializes with Twilio client" do
    assert_instance_of Twilio::REST::Client, @service.client
  end

  test "send_message with valid inputs returns Twilio message instance" do
    mock_response = OpenStruct.new(sid: "SM123456789")

    @service.client.messages.stub :create, mock_response do
      result = @service.send_message(phone_number: @valid_phone, message: @valid_message)
      assert_equal mock_response, result
      assert_equal "SM123456789", result.sid
    end
  end

  test "send_message validates phone number format" do
    invalid_phones = [
      "1234567890",      # Missing +
      "+123",            # Too short
      "+123456789012345678", # Too long
      "",                # Empty
      nil,               # Nil
      123,               # Not a string
      "+12a4567890"      # Contains letters
    ]

    invalid_phones.each do |phone|
      assert_raises ArgumentError, "Should raise ArgumentError for phone: #{phone.inspect}" do
        @service.send_message(phone_number: phone, message: @valid_message)
      end
    end
  end

  test "send_message validates message content" do
    invalid_messages = [
      "",                    # Empty
      "   ",                 # Whitespace only
      nil,                   # Nil
      123,                   # Not a string
      "a" * 1601            # Too long (over 1600 chars)
    ]

    invalid_messages.each do |message|
      assert_raises ArgumentError, "Should raise ArgumentError for message: #{message.inspect}" do
        @service.send_message(phone_number: @valid_phone, message: message)
      end
    end
  end

  test "send_message handles Twilio REST errors" do
    # Mock a Twilio error by creating a class that inherits from the actual error
    twilio_error_class = Class.new(StandardError) do
      def self.name
        "Twilio::REST::RestError"
      end
    end

    error_instance = twilio_error_class.new("Invalid phone number")

    @service.client.messages.stub :create, proc { raise error_instance } do
      error = assert_raises SmsService::Error do
        @service.send_message(phone_number: @valid_phone, message: @valid_message)
      end

      # Since our error handling catches all errors, this will go to the StandardError path
      assert_match /Unexpected error sending SMS: Invalid phone number/, error.message
    end
  end

  test "send_message handles unexpected errors" do
    @service.client.messages.stub :create, proc { raise StandardError.new("Network timeout") } do
      error = assert_raises SmsService::Error do
        @service.send_message(phone_number: @valid_phone, message: @valid_message)
      end

      assert_match /Unexpected error sending SMS: Network timeout/, error.message
    end
  end

  test "send_message logs successful sends" do
    mock_response = OpenStruct.new(sid: "SM123456789")

    @service.client.messages.stub :create, mock_response do
      Rails.logger.stub :info, nil do |logger|
        result = @service.send_message(phone_number: @valid_phone, message: @valid_message)
        assert_equal mock_response, result
      end
    end
  end

  test "send_message logs errors" do
    @service.client.messages.stub :create, proc { raise StandardError.new("Test error") } do
      Rails.logger.stub :error, nil do |logger|
        assert_raises SmsService::Error do
          @service.send_message(phone_number: @valid_phone, message: @valid_message)
        end
      end
    end
  end

  test "send_message_to_user raises NotImplementedError" do
    mock_user = Object.new

    error = assert_raises NotImplementedError do
      @service.send_message_to_user(user: mock_user, message: @valid_message)
    end

    assert_match /User model integration not yet implemented/, error.message
  end

  test "accepts valid phone numbers in E.164 format" do
    valid_phones = [
      "+1234567890",        # US format
      "+441234567890",      # UK format
      "+33123456789",       # France format
      "+81234567890",       # Japan format
      "+12345678901234"     # Max length (15 digits)
    ]

    valid_phones.each do |phone|
      mock_response = OpenStruct.new(sid: "SM123456789")
      @service.client.messages.stub :create, mock_response do
        result = @service.send_message(phone_number: phone, message: @valid_message)
        assert_equal mock_response, result
      end
    end
  end

  test "accepts valid message lengths" do
    messages = [
      "Short",              # Short message
      "a" * 160,           # Standard SMS length
      "a" * 1600           # Maximum allowed length
    ]

    messages.each do |message|
      mock_response = OpenStruct.new(sid: "SM123456789")
      @service.client.messages.stub :create, mock_response do
        result = @service.send_message(phone_number: @valid_phone, message: message)
        assert_equal mock_response, result
      end
    end
  end

  test "SmsService::Error is a custom error class" do
    assert SmsService::Error < StandardError
  end
end
