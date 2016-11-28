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

class PushCondition < ActiveRecord::Base
  has_many :push_texts, dependent: :destroy
  accepts_nested_attributes_for :push_texts, allow_destroy: true

  scope :by_temperature_range, -> (temperature) {
    where('minimum_temperature is null or ? between minimum_temperature and maximum_temperature', temperature)
  }
  scope :by_humidity_range, -> (humidity) {
    where('minimum_humidity is null or ? between minimum_humidity and maximum_humidity', humidity)
  }
  scope :by_time_of_a_day, -> (time_of_a_day) { where(time_of_a_day: time_of_a_day) }

  # validates :minimum_temperature, :maximum_temperature, :minimum_humidity, :maximum_humidity, :time_of_a_day, presence: true
  validates :time_of_a_day, presence: true

  def unique_message(user)
    # retrives all the messages sent to the user from this condition
    sent_texts = push_texts.sent_to_user(user)

    # if we find sent_texts
    if sent_texts.present?
      # try to find one that we do not sent yet
      push_text = push_texts.where('id not in (?)', sent_texts).order(:created_at).first
    else
      # otherwise get the first one to be sent
      push_text = push_texts.order(:created_at).first
    end

    # if we find a push_text
    if push_text
      # mark it as sent
      push_text.users << user
      # reset the message to be sent again in 30 days
      push_text.delay(run_at: 30.days.from_now).delete_user(user)
    end

    # replace the user variable
    result = push_text.try(:text)
    result = result % { user: user.first_name } if result
    result
  end
end
