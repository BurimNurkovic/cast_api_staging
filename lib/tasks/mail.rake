namespace :mailer do
  desc 'Send welcome email to all users'
  task send_welcome: :environment do
    User.all.each do |user|
      # p user.email
      UserMailer.welcome_email user
      # break
    end
  end

end
