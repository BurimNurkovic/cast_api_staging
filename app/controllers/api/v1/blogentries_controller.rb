class Api::V1::BlogentriesController < InheritedResources::Base
  def index
    @blogentries = Blogentry.published.order(id: :desc).page(params[:page]).per(params[:per])
  end

  def show
    @blogentry = Blogentry.published.find(params[:id])
  end
end
