module Weather
  class Wunderground

    def self.search_weather_for(link: nil,latitude: nil, longitude: nil)
      if latitude && longitude
        geolookup = JSON.parse(HTTP.get("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/geolookup/q/#{latitude},#{longitude}.json"))

        unless geolookup["response"]["error"]
          w_id = geolookup["location"]["l"]

          conditions = JSON.parse(HTTP.get("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/conditions#{w_id}.json"))
          ten_day_forecast = JSON.parse(HTTP.get("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/forecast10day#{w_id}.json"))

          w_info_obj = generate_weather_object(conditions, ten_day_forecast)
        else
          geolookup["response"]["error"]["query_for"] = "geolookup"
          w_info_obj = { error: geolookup["response"]["error"] }
        end
      elsif link
        w_id = link
        conditions = JSON.parse(HTTP.get("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/conditions#{w_id}.json"))
        ten_day_forecast = JSON.parse(HTTP.get("http://api.wunderground.com/api/#{ENV['WUNDERGROUND_KEY']}/forecast10day#{w_id}.json"))
        unless conditions["response"]["error"] || ten_day_forecast["response"]["error"]
          w_info_obj = generate_weather_object(conditions, ten_day_forecast)
        else
          conditions["response"]["error"]["query_for"] = "conditions"
          ten_day_forecast["response"]["error"]["query_for"] = "ten_day_forecast"
          w_info_obj = { error: [conditions["response"]["error"], ten_day_forecast["response"]["error"]] }
        end
      end

      w_info_obj
    end

    def self.generate_weather_object(conditions, ten_day_forecast)
      w_info_obj = {}

      w_info_obj[:feels_like] = conditions["current_observation"]["feelslike_f"]
      w_info_obj[:display_name] = conditions["current_observation"]["display_location"]["full"]
      w_info_obj[:humidity] = conditions["current_observation"]["relative_humidity"]
      w_info_obj[:link] = "zmw:" + conditions["current_observation"]["display_location"]["zip"] + "." + conditions["current_observation"]["display_location"]["magic"] + "." + conditions["current_observation"]["display_location"]["wmo"]
      w_info_obj[:name] = conditions["current_observation"]["display_location"]["city"] + ", " + conditions["current_observation"]["display_location"]["country"]
      w_info_obj[:precipitation] = conditions["current_observation"]["precip_today_metric"]
      w_info_obj[:temp_current] = conditions["current_observation"]["temp_f"]
      w_info_obj[:temp_max] = ten_day_forecast["forecast"]["simpleforecast"]["forecastday"][0]["high"]["fahrenheit"]
      w_info_obj[:temp_min] = ten_day_forecast["forecast"]["simpleforecast"]["forecastday"][0]["low"]["fahrenheit"]
      w_info_obj[:uvIndex] = conditions["current_observation"]["UV"]
      w_info_obj[:weather] = conditions["current_observation"]["weather"]
      w_info_obj[:wind] = "#{conditions["current_observation"]["wind_mph"]} MPH #{conditions["current_observation"]["wind_dir"]}"
      w_info_obj[:forcast] = []

      ten_day_forecast["forecast"]["simpleforecast"]["forecastday"].each do |day|
        forecast_day_obj = {}
        forecast_day_obj[:conditions] = day["conditions"]
        forecast_day_obj[:image_url] = day["icon_url"]
        forecast_day_obj[:short_name] = day["date"]["weekday_short"]
        forecast_day_obj[:temp_max] = day["high"]["fahrenheit"]
        forecast_day_obj[:temp_max] = day["low"]["fahrenheit"]

        w_info_obj[:forcast] << forecast_day_obj
      end

      w_info_obj
    end

  end
end
