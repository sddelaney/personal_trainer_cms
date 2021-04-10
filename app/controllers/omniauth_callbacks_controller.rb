class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token  
  # before_action :initialize_omniauth_state

  def failure
    Rails.logger.info "----------Failed Login--------"
    redirect_to root_url, :alert => "Authentication error: #{params[:message]}"
  end


  def google_oauth2
    Rails.logger.info "-------Successful Google Login--------"
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    user.save!
    user.remember_me = true
    sign_in(:user, user)
    redirect_to after_sign_in_path_for(user)
  end

  def oauth2callback
    logger.info "callback"
  end
    protected

  # def initialize_omniauth_state
  #   session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  # end
end