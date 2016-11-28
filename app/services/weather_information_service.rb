class WeatherInformationService
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :location_params, Hash

  def call
    weather_request
  end

  private
  def weather_request
    results = Rails.cache.fetch(weather_cache_key, expires_in: 1.hour) do
      Weather::Wunderground.search_weather_for location_params
    end
    Rails.cache.delete(weather_cache_key) if results.keys.include?(:error)
    results
  end

  def weather_cache_key
    if location_params[:link]
      "WeatherInformation/#{location_params[:link].parameterize.underscore}"
    elsif location_params[:latitude] && location_params[:longitude]
      "WeatherInformation/#{location_params[:latitude].parameterize.underscore}/#{location_params[:longitude].parameterize.underscore}"
    else
      raise ArgumentError, 'Link or Latitude/Longitude required'
    end
  end
end
