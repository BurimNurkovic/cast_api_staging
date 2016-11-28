class UserMailer < ActionMailer::Base
  default from: 'info@castlife.co'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email user
    require 'mandrill'

    return if user.email.blank?
    email = user.email
    p ENV['MANDRILL_APIKEY']

    mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    template_name = ENV['MANDRILL_TEMPLATE']
    message = {
      'recipient_metadata'=>
        [{ 'values' => { 'user_id' => user.id }, 'rcpt' => email }],
      'merge_vars' => [{
        'vars' => [{ 'name' => 'first_name', 'content' => user.first_name }],
        'rcpt' => email
      }],
      'to'=> [{ 'email' => email, 'type' => 'to', 'name'=> "#{ user.first_name } #{ user.last_name }" }],
    }
    p mandrill.messages.send_template template_name, [], message
  end
end
