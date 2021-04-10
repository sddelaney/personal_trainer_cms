class TrainingsessionsController < ApplicationController
  before_action :restrict_access
  before_action :set_trainingsession, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!

  # GET /trainingsessions
  def index
    redirect_to users
  end

  # GET /trainingsessions/new
  def new
    @trainingsession = Trainingsession.new
  end

  # Decrement sessions for user
  # POST /trainingsessions
  def create
    # If calendar event is not client session - skip it
    unless ["filter1", "filter2"].any? { |ignorable| params[:title].downcase.include? ignorable }

      if user = User.where('lower(name) = ?', params[:title].sub("PT- ", "").downcase).first
        if user.training_sessions
          # TODO move this to user?
          # If two sessions happen within 5 hours it is likely a mistake from gcal
          unless user.last_session? && user.last_session > 5.hours.ago
            user.last_session = DateTime.now
            use_session(user)
          end
        else
          twilio("User #{params[:title]} had a session with none available.")
        end
      else
        twilio("Unknown user from calendar event: #{params[:title]}" )
      end
    end
  end

  private

    def use_session(user)
      user.decrement!(:training_sessions)
      notif = "#{user.name} used 1 session for a new total of #{user.training_sessions} sessions."
      logger.info notif
      user.microposts << Micropost.new(content:notif, user_id: user.id)
      user.save
      unless user.training_sessions > 0
        twilio("#{user.name} is out of sessions.")
      end
    end

    def twilio(notif)
      TwilioClient.new.send_text(notif)
      logger.info notif
    end
    def restrict_access
      api_key = ApiKey.find_by_access_token(params[:access_token])
      head :unauthorized unless api_key
    end  
end
