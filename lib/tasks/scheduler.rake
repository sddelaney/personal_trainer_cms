task :send_email => :environment do
  User.send_admin_email
end