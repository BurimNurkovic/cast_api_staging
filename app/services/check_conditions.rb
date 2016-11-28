class CheckConditions
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model

  attribute :user, User
  attribute :time_of_a_day, String
  attribute :type, Symbol

  attribute :current_weather, BarometerClient::CurrentWeather, writer: :private
  attribute :push_message, String, writer: :private
  attribute :amazon_tags, String


  def call
    if user.latitude.present? && user.longitude.present?
      check_current_weather
      select_push_message
      send_push_note
    end
  end

  private

  def check_current_weather
    self.current_weather = BarometerClient.get_weather(latitude: user.latitude, longitude: user.longitude)
  end

  def select_push_message
    case type
      when :hair
        # self.push_message, self.amazon_tags = HairCondition.message_for_weather(current_weather.temperature, current_weather.humidity, time_of_a_day, user)
        self.push_message, self.amazon_tags = HairCondition.message_for_weather(current_weather.temperature, time_of_a_day, user)
      when :skin
        # self.push_message, self.amazon_tags = SkinCondition.message_for_weather(current_weather.temperature, current_weather.humidity, time_of_a_day, user)
        self.push_message, self.amazon_tags = SkinCondition.message_for_weather(current_weather.temperature, time_of_a_day, user)
    end
  end

  def send_push_note
    if push_message
      # ParseClient.send_push_to_user(recipient_id: user.installation_id, alert: push_message, amazon_tags: amazon_tags)
      Sns.send_push_to_user user: user, alert: push_message, amazon_tags: amazon_tags
    end
  end
end
