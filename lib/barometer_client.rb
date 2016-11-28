module BarometerClient
  def self.get_weather(latitude:, longitude:)
    barometer = Barometer.new("#{latitude},#{longitude}")
    current_weather = barometer.measure.current
    CurrentWeather.new(current_weather.temperature, current_weather.humidity)
  end

  class CurrentWeather
    def initialize(celsius_temperature, humidity)
      @temperature, @humidity = to_fahrenheit(celsius_temperature).round.to_i, humidity.round.to_i
    end

    attr_accessor :temperature, :humidity

    private

    def to_fahrenheit(celsius)
      (1.8 * celsius.to_f) + 32
    end
  end
end
