class Api::V1::ProductsController < Api::V1::BaseController
  # use amazon api to search products
  before_action :check_weather, only: [:index]

  def index
    if !@weather_info[:error]
      skin_keyword_array = Weather::KeywordBuilder.skin_keywords_for(@weather_info)
      hair_keyword_array = Weather::KeywordBuilder.hair_keywords_for(@weather_info)

      user = User.find_by_auth_token(params[:auth_token])

      if params[:unify_products] == 'true'
        products_limit = 5
        params[:prioritize_brands] = true
      else
        products_limit = 10
        params[:prioritize_brands] = false
      end
      # products_limit = params[:products_limit] ||= 10

      @products = CastProductSearchService.call(
        user: user, request_params: request_params,
        hair_item_page: params[:hair_item_page],
        skin_item_page: params[:skin_item_page],
        unify_products: (params[:unify_products] == 'true'),
        products_limit: (products_limit.to_i),
        prioritize_brands: (params[:prioritize_brands] == 'true'),
        hair_keywords: hair_keyword_array, skin_keywords: skin_keyword_array
        )
      render json: @products
    end
  end

  def search
    user = User.find_by_auth_token(params[:auth_token])

    @products = AmazonProductSearchService.call(
      user: user, request_params: loggable_params,
      item_page: params[:item_page],
      keywords: params[:keywords]
    )
    render json: @products

  end

  private
  def request_params
    weather_params = {
      temperature: @weather_info[:temp_current], humidity: @weather_info[:humidity],
      wind: @weather_info[:wind], precipitation: @weather_info[:precipitation],
    }

    loggable_params.merge(weather_params)
  end

  def loggable_params
    params.select do |key, value|
      %(controller action format hair_item_page skin_item_page item_page auth_token).exclude?(key.to_s)
    end
  end

  def check_weather
    location_params = {
      link: params[:link],
      latitude: params[:latitude],
      longitude: params[:longitude]
    }

    @weather_info = WeatherInformationService.call location_params: location_params

    render json: @weather_info if @weather_info[:error]
  end
end
