require 'faraday'
require 'json'
require 'ostruct'
require 'date'
require 'optparse'

class WeatherController < ApplicationController
	
	def retrieve_info
		if params[:latitude] && params[:longitude]
			geolookup = JSON.parse(HTTP.get("http://api.wunderground.com/api/c86d37088090cd44/geolookup/q/#{params[:latitude]},#{params[:longitude]}.json"))

			unless geolookup["response"]["error"]
				w_id = geolookup["location"]["l"]

				conditions = JSON.parse(HTTP.get("http://api.wunderground.com/api/c86d37088090cd44/conditions#{w_id}.json"))
				ten_day_forecast = JSON.parse(HTTP.get("http://api.wunderground.com/api/c86d37088090cd44/forecast10day#{w_id}.json"))

				w_info_obj = generate_weather_object(conditions, ten_day_forecast)
			else
				geolookup["response"]["error"]["query_for"] = "geolookup"
				w_info_obj = { error: geolookup["response"]["error"] }
			end
		elsif params[:link]
			w_id = params[:link]
			conditions = JSON.parse(HTTP.get("http://api.wunderground.com/api/c86d37088090cd44/conditions#{w_id}.json"))
			ten_day_forecast = JSON.parse(HTTP.get("http://api.wunderground.com/api/c86d37088090cd44/forecast10day#{w_id}.json"))
			unless conditions["response"]["error"] || ten_day_forecast["response"]["error"]
				w_info_obj = generate_weather_object(conditions, ten_day_forecast)
			else
				conditions["response"]["error"]["query_for"] = "conditions"
				ten_day_forecast["response"]["error"]["query_for"] = "ten_day_forecast"
				w_info_obj = { error: [conditions["response"]["error"], ten_day_forecast["response"]["error"]] }
			end
		end

		render json: w_info_obj
	end


	def retrieve_weathermap
		if params[:latitude] && params[:longitude]
			raw_data = Faraday.get("http://api.openweathermap.org/data/2.5/weather?lat=#{params[:latitude]}&lon=#{params[:longitude]}&APPID=442eba5b3e3a3ae8ead5698479bcdaa8").body
			puts raw_data
			geolookup = JSON.parse(raw_data, object_class: OpenStruct)
			if geolookup["cod"] == 200
				w_info_obj = generate_openweathermap_geolookup_object(geolookup)
			else 
				w_info_obj = { error: [geolookup["message"], geolookup["cod"]] }
			end
		elsif params[:city]
			raw_data = Faraday.get("http://api.openweathermap.org/data/2.5/forecast?q=#{params[:city]}&units=imperial&APPID=442eba5b3e3a3ae8ead5698479bcdaa8").body
  			forecasts = JSON.parse(raw_data, object_class: OpenStruct)
  			# puts raw_data
			w_info_obj = generate_openweathermap_forcast_object(forecasts)
		end

		render json: w_info_obj
	end

	def retrieve_products
		time = Time.now.to_s
		time[10] = "T"
		time = time.gsub(":","%3A")
		time = time[0..-7]
		time += ".000Z"

		# Signiture query
		req = HTTP.get("https://webservices.amazon.com/onca/xml?AWSAccessKeyId=AKIAJPDWGVF6KZSVOROQ&AssociateTag=AKIAILVKPSLJF5ZV5IUQ&ItemPage=2&Keywords=normal%20skin%20&Operation=ItemSearch&ResponseGroup=Small%2C%20Images%2C%20OfferSummary&SearchIndex=Beauty&Service=AWSECommerceService&Timestamp=#{time}&Version=2013-08-01")

		puts "*" * 50
		# "http://webservices.amazon.co.uk/onca/xml?
		# AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&
		# Actor=Johnny%20Depp&
		# AssociateTag=mytag-20&
		# Operation=ItemSearch&
		# Operation=ItemSearch&
		# ResponseGroup=ItemAttributes%2COffers%2CImages%2CReviews%2CVariations&
		# SearchIndex=DVD&
		# Service=AWSECommerceService&
		# Sort=salesrank&
		# Timestamp=2014-08-18T17%3A34%3A34.000Z&
		# Version=2013-08-01"

		puts time
		# "http://webservices.amazon.co.uk/onca/xml?
		# AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&
		# Actor=Johnny%20Depp&
		# AssociateTag=mytag-20&
		# Operation=ItemSearch&
		# Operation=ItemSearch&
		# ResponseGroup=ItemAttributes%2COffers%2CImages%2CReviews%2CVariations&
		# SearchIndex=DVD&
		# Service=AWSECommerceService
		# &Sort=salesrank&
		# Timestamp=2014-08-18T17%3A34%3A34.000Z&
		# Version=2013-08-01&
		# Signature=Gv4kWyAAD3xgSGI86I4qZ1zIjAhZYs2H7CRTpeHLD1o%3D"

		puts "*" * 50


		# res = Hash.from_xml(req).to_json
		render json: req
	end

	def autocomplete_query
		base_uri = "http://autocomplete.wunderground.com/aq?query="
		if params[:city]
			parameter_of_uri = "#{params[:city]}"
		else
			parameter_of_uri = ""
		end
		uri = URI.escape("#{base_uri}#{parameter_of_uri}&h=1")
		# res = JSON.parse(HTTP.get(uri))

		# q_obj = []
		# res["RESULTS"].each do |loc_obj|

		# 	if loc_obj["type"] == "city"
		# 		state = loc_obj['name'].split(",")
		# 		state_short = Location.us_states(state[1].lstrip)
		# 		location_name = state_short.present? ? (state[0] + ', ' + state_short) : (state[0] + ', ' + loc_obj['c'])
		# 		# # No need to swap out the state name with country, we want state.
		# 		# g_city_col = []
		# 		# str_to_arr = loc_obj["name"].split(",")
		# 		# g_city_col << str_to_arr[0]
		# 		# g_city_col << ", "
		# 		# g_city_col << loc_obj["c"]
		# 		#
		# 		# formatted_city_str = g_city_col.join("")

		# 		q_obj << { display_name: location_name, link: loc_obj['l'] }
		# 	else
		# 		next
		# 	end
		# end
		# render json: q_obj

		locations = JSON.parse(HTTP.get(uri))
		location_obj = generate_autocomplet_object(locations)    

		render json: location_obj
	end

		protected

	def generate_weather_object(conditions, ten_day_forecast)
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
			forecast_day_obj[:temp_min] = day["low"]["fahrenheit"]

			w_info_obj[:forcast] << forecast_day_obj
		end

		w_info_obj
	end

	def generate_openweathermap_forcast_object(forecasts)
		w_info_obj = {}
		w_info_obj[:forcast] = []
		forecasts.list.map do |forecast|
	      forecast_day_obj= {}
	      puts forecast
	      forecast_day_obj[:datetime] = forecast.dt_txt
	      forecast_day_obj[:temp] = forecast.main.temp
	      forecast_day_obj[:description] = forecast.weather.first.description
	      w_info_obj[:forcast] << forecast_day_obj
	    end

		w_info_obj
	end
	
	def generate_openweathermap_geolookup_object(geolookup)
		w_info_obj = {}
		w_info_obj[:forcast] = []
		forecast_day_obj= {}
		puts geolookup
		forecast_day_obj[:temp] = geolookup.main.temp
    	forecast_day_obj[:description] = geolookup.weather.first.description
      	w_info_obj[:forcast] << forecast_day_obj

		w_info_obj
	end

	def generate_autocomplet_object(locations)
		locations_obj = []

		locations["RESULTS"].each do |location|

			if location["type"] == "city"
				# puts JSON.pretty_generate(location)
				state = location['name'].split(",")
				state_short = Location.us_states(state[1].lstrip)
				location_name = state_short.present? ? (state[0] + ', ' + state_short) : (state[0] + ', ' + location['c'])
				# # No need to swap out the state name with country, we want state.
				# g_city_col = []
				# str_to_arr = location["name"].split(",")
				# g_city_col << str_to_arr[0]
				# g_city_col << ", "
				# g_city_col << location["c"]
				#
				# formatted_city_str = g_city_col.join("")
				locations_obj << { display_name: location_name, link: location['l'], 
								   latitude: location['lat'], longitude: location['lon'],
								   timezone: location['tz'] }
			end

		end

		locations_obj
	end

end
