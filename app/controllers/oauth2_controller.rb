class Oauth2Controller < ApplicationController
  def oauth2callback
    @google_api = GoogleSlides.new
    @google_api.auth_client.code = params[:code] if params[:code]
    @google_api.auth_client.fetch_access_token!
    @auth = @google_api.auth_client

    Token.create(
      Credentials: @auth.to_json,
      access_token: @auth.access_token,
      refresh_token: @auth.refresh_token,
      expires_at: Time.at(@auth.expires_at.to_i).to_datetime)
    redirect_to users_path
  end

end


