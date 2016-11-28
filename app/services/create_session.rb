class CreateSession
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :session_params, Hash

  attribute :user, User
  attribute :errors, Hash

  def call
    if facebook_authorization?
      authorization_result = facebook_authorized?
      if authorization_result[:success]
        user.regenerate_token!
        respond_with_user
      else
        render_error(authorization_result[:errors])
      end
    elsif amazon_authorization?
      authorization_result = amazon_authorized?
      if authorization_result[:success]
        user.regenerate_token!
        respond_with_user
      else
        render_error(authorization_result[:errors])
      end
    else
      find_user
      if signed_in?
        user.regenerate_token!
        respond_with_user
      else
        render_error(session: ['Your email/password pair is incorrect'])
      end
    end
  end

  private

  def facebook_authorization?
    session_params['facebook_id'].present?
  end

  def amazon_authorization?
    session_params['amazon_id'].present? || session_params[:amazon_id].present?
  end

  def facebook_authorized?
    graph = FacebookGraph.new(session_params['facebook_session'])
    id = graph.id
  rescue Koala::Facebook::AuthenticationError => e
    self.errors = { oauth: e.fb_error_message }
  else
    if id == session_params['facebook_id']
      self.user = User.find_by_facebook_id(session_params['facebook_id'])
    else
      self.errors = { 'facebook_auth' => ['Your facebook_id/facebook_session pair is incorrect'] }
    end
  ensure
    return { success: user.present?, errors: errors }
  end

  def amazon_authorized?
    response = AmazonClient.authorize(token: session_params['amazon_session'])
    if response['user_id'].present?
      if response['user_id'] == session_params['amazon_id']
        self.user = User.find_by_amazon_id(session_params['amazon_id'])
        if user.nil?
          self.errors = { 'amazon_id' => ['There is no user with this ID in database'] }
        end
      else
        self.errors = { 'amazon_auth' => ['Your amazon_id/amazon_session pair is incorrect'] }
      end
    else
      self.errors = { oauth: response['error_description'] }
    end
    { success: user.present?, errors: errors }
  end

  def find_user
    self.user = User.find_for_database_authentication(email: session_params['email'])
  end

  def signed_in?
    user && user.valid_password?(session_params['password'])
  end

  def respond_with_user
    { success: true, respond_with_arguments: [:api, :v1, user] }
  end

  def render_error(errors)
    { success: false, render_arguments: [json: {errors: errors}, status: 401] }
  end
end
