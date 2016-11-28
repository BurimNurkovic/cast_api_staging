# == Schema Information
#
# Table name: push_conditions
#
#  id                  :integer          not null, primary key
#  skin_type           :string(255)
#  hair_type           :string(255)
#  minimum_temperature :integer
#  maximum_temperature :integer
#  minimum_humidity    :integer
#  maximum_humidity    :integer
#  time_of_a_day       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  amazon_tags         :string(255)
#  type                :string(255)
#

class SkinCondition < PushCondition
  validates :skin_type, presence: true

  # def self.message_for_weather(temperature, humidity, time_of_a_day, user)
  def self.message_for_weather(temperature, time_of_a_day, user)
    # condition = by_temperature_range(temperature).by_humidity_range(humidity).by_time_of_a_day(time_of_a_day)
    condition = by_temperature_range(temperature).by_time_of_a_day(time_of_a_day)
    condition = condition.where('skin_type = (?)', user.skin_type).first
    if condition
      return condition.unique_message(user), condition.amazon_tags
    else
      return nil
    end
  end
end
