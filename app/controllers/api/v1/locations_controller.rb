class Api::V1::LocationsController < Api::V1::BaseController
  before_action :authorize

  def index
    render json: current_user.locations
  end

  def create
    location = Location.new({ user: current_user, display_name: params[:display_name], link: params[:link] })
    if location.save
      render json: { message: 'Location added successfully' }
    else
      render json: { error: 'Error adding location' }
    end
  end

  def destroy
    current_user.locations.find(params[:id]).destroy
    render json: { message: 'Location added successfully' }
  end
end
