class Api::V1::FavoritesController < Api::V1::BaseController
  before_action :authorize

  def index
    render json: { amazon_ids: @current_user.favorites.pluck(:amazon_id), favorites: @current_user.favorites_attributes }
  end

  def create
    favorites = params[:amazon_ids].map do |amazon_id|
      favorite = @current_user.favorites.build(amazon_id: amazon_id)
      favorite.try(:public_attributes) if favorite.save
    end
    render json: { favorites: favorites },
      status: favorites.include?(nil) ? :unprocessable_entity : :ok
  end

  def delete_collection
    @current_user.favorites.where(amazon_id: params[:amazon_ids]).destroy_all
    render json: { amazon_ids: @current_user.favorites.pluck(:amazon_id), favorites: @current_user.favorites_attributes }
  end
end
