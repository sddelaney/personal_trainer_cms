require 'twilio-ruby'
class TwilioClient
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]
  end

  def send_text(message)
    if Rails.env.production?
      phone_numbers.each do |num|
        @client.messages.create(
        to: num,
        from: phone_number,
        body: message
      )
      end
    end
  end

  private
    def phone_numbers
      [ENV["MY_PHONE"], ENV["SECOND_PHONE"]]
    end
    def phone_number
      ENV["TWILIO_PHONE"]
    end
end