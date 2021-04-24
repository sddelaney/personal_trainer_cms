class GoogleSlides
  attr_accessor :auth_client, :auth_uri, :code

  def initialize
      client_secrets = Google::APIClient::ClientSecrets.load
      Rails.logger.info "33333333333333#{ENV["HOSTNAME"]}"
      @auth_client = client_secrets.to_authorization 
      @auth_client.update!(
        # Reduce access of scope later
        :scope => 'https://www.googleapis.com/auth/drive',
        :redirect_uri => "#{ENV["HOSTNAME"]}oauth2callback",
        :additional_parameters => {
          "access_type" => "offline",         # offline access
          "approval_prompt" => "force",       # Needed for first token generation
          "include_granted_scopes" => "true"  # incremental auth
        }
      )
      @auth_uri = @auth_client.authorization_uri.to_s
  end
  

  def self.drive_setup(token)
    drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = token
    drive
  end

  def self.slides_setup(token)
    slides = Google::Apis::SlidesV1::SlidesService.new
    slides.authorization = token
    slides
  end

end
