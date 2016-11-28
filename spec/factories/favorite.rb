FactoryGirl.define do
  factory :favorite do
    amazon_id
    user_id 123

    after(:build) { |obj| obj.class.skip_callback(:create, :before, :update_advert_info) }

    trait :with_before_save do
      after(:build) { |obj| obj.class.set_callback(:create, :before, :update_advert_info) }
    end
  end

  sequence(:amazon_id) do |n|
    "8asd9a#{n}"
  end
end
