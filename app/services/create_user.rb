class CreateUser
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :user_params, Hash

  def call
    if facebook_registration?
      register_with_facebook
    elsif amazon_registration?
      register_with_amazon
    else
      regular_registration
    end
  end

  private

  %w(facebook amazon).each do |provider|
    define_method("register_with_#{provider}") do
      if send("existent_#{provider}_user?")
        send("#{provider}_user_exists")
      else
        send("create_new_#{provider}_user")
      end
    end

    define_method("#{provider}_registration?") do
      user_params["#{provider}_id"].present?
    end

    define_method("existent_#{provider}_user?") do
      User.send("find_by_#{provider}_id", user_params["#{provider}_id"])
    end

    define_method("#{provider}_user_exists") do
      new_record = User.new
      new_record.errors.add("#{provider}_id", 'already exists')
      new_record
    end
  end

  def regular_registration
    new_record = User.create(user_params)
    p new_record
    UserMailer.welcome_email(new_record).deliver_later
    new_record
  end

  def create_new_facebook_user
    graph = FacebookGraph.new(user_params['facebook_session'])
    id = graph.id
  rescue Koala::Facebook::AuthenticationError => e
    new_record = record_with_errors(:oauth, e.fb_error_message)
  else
    if id == user_params['facebook_id']
      new_record = User.create(user_params.except('facebook_session'))
      p new_record
      UserMailer.welcome_email(new_record).deliver_later
    else
      new_record = record_with_errors(:facebook_id, "facebook_session doesn't match with id sent")
    end
  ensure
    return new_record
  end

  def create_new_amazon_user
    response = AmazonClient.authorize(token: user_params['amazon_session'])
    if response['user_id'].present?
      if response['user_id'] == user_params['amazon_id']
        new_record = User.create(user_params.except('amazon_session'))
        p new_record
        UserMailer.welcome_email(new_record).deliver_later
      else
        new_record = record_with_errors(:amazon_id, "amazon_session doesn't match with id sent")
      end
    else
      new_record = record_with_errors(:amazon_api, response['error_description'])
    end
    new_record
  end

  def record_with_errors(field, message)
    new_record = User.new
    new_record.errors.add(field, message)
    new_record
  end
end
