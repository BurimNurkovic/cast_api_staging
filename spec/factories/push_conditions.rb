FactoryGirl.define do
  factory :push_condition do
    skin_type 'normal'
    time_of_a_day '9am'
    minimum_temperature 60
    maximum_temperature 80
    minimum_humidity 60
    maximum_humidity 70
  end
end
