class Api::V1::ShoppingCartsController < Api::V1::BaseController
  before_action :authorize

  def create
    call_service amazon_id: params[:amazon_id], quantity: params[:quantity]
  end

  # unify create and update method
  alias_method :update, :create

  def show
    call_service
  end

  # Remove items from the cart
  def destroy
    call_service amazon_id: params[:amazon_id]
  end

  def finish
    if current_user.finish_shopping_cart!
      render json: { messages: ['Shopping Cart Finished'] }, status: :ok
    else
      render json: { errors: ['The Shopping Cart could not be Finished'] }, status: :unprocessable_entity
    end
  end

  def call_service(action_params = {})
    result = ShoppingCartService.call({ user: current_user, method: action_name }.merge action_params)
    render *result[:render_arguments]
  end
end
