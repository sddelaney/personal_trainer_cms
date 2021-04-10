class UserMailer < ApplicationMailer
  default from: ENV["MY_EMAIL"]
  # def welcome_email
  #   @user = params[:user]
  #   @url  = "http://#{ENV["hostname"]}:3000/login"
  #   mail(to: @user.email, subject: 'Welcome to Liv Nation')
  # end
  def admin_email
    if Rails.env.production?
      @url  = "#{ENV["HOSTNAME"]}:3000"
      @users = User.all
      mail(to: ENV["ADMIN_EMAIL"],cc: ENV["MANAGER_EMAIL"], subject: 'Liv Nation Session Report')
    end
  end
end