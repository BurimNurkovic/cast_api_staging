FactoryGirl.define do
  factory :user do
    email
    password 'test'
    first_name 'Sarah'
    last_name 'Johns'
    age '18-24'
    hair_type 'straight'
    skin_type 'normal'
    latitude 37.8267
    longitude -122.423

    factory :facebook_user do
      facebook_id '100004866240221'
      email 'test@mail.com'
      password '' # for devise
    end

    factory :amazon_user do
      sequence(:amazon_id) { |n| "amzn1.account.A#{n}EM6TWKKDA6W5E6QFXRC7FAWPOOA" }
      email
      password '' # for devise
      installation_id 'dfs7f9sd7f9s'
    end
  end

  sequence(:email) do |n|
    "user#{n}@example.com"
  end
end
