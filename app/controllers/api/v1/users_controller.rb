class Api::V1::UsersController < Api::V1::BaseController
  before_action :authorize, except: [:create, :test_push]

  def create
    @user = CreateUser.call(user_params: user_params)
    if @user.valid?
      respond_with :api, :v1, @user
    else
      if @user.errors.messages.keys.include? :oauth
        render json: { error: 'Sorry, we couldn\'t retrieve your Facebook information' }, status: :unprocessable_entity
      elsif @user.errors.messages.keys.include?(:facebook_id) || @user.errors.messages.keys.include?(:amazon_id)
        render json: { error: 'Sorry, we are unable to access your Amazon account at this time' }, status: :unprocessable_entity
      else
        respond_with :api, :v1, @user
      end
    end

  end

  def test_push
    sns = AWS::SNS::Client.new
    endpoint = sns.create_platform_endpoint(
      platform_application_arn: 'arn:aws:sns:us-east-1:217859432301:app/GCM/cast-android',
      token: params[:reg_id],
      attributes: { 'UserId' => '1' }
    )
    res = sns.publish target_arn: endpoint, message: 'test'
    render json: res
  end

  def update
    result = UpdateUser.call(user: @current_user, id: params[:id], user_params: user_params)
    if result[:success]
      render *result[:render_arguments]
    else
      render json: { error: 'Sorry, we are unable to update your profile at this time.' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :first_name, :last_name, :password, :age, :hair_type, :skin_type, :latitude, :longitude, :installation_id,
                  :facebook_id, :facebook_session, :amazon_id, :amazon_session, :avatar, :content_type, :filename)
  end
end
