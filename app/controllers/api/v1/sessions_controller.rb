class Api::V1::SessionsController < Api::V1::BaseController
  def create
    return_user.present? ? (render json: return_user and return) : nil

    result = CreateSession.call(session_params: session_params)
    if result[:success]
      respond_with *result[:respond_with_arguments]
    else
      render *result[:render_arguments]
    end
  end

  private

  def session_params
    params.permit(:email, :password, :facebook_id, :facebook_session, :amazon_id, :amazon_session, :auth_token)
  end

  def return_user
    User.find_by_auth_token(session_params[:auth_token])
  end
end
