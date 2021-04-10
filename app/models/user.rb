
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
    has_many :microposts
    has_many :workouts
    validates :name, presence: true, uniqueness: {case_sensitive: false}
    validates :email, presence: true, uniqueness: true
def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
      #user.password = SecureRandom.hex
    end
  end
  def self.send_admin_email
    UserMailer.admin_email.deliver!
  end

end
