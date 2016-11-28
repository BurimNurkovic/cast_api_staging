FactoryGirl.define do
  factory :answer do
    # question_id
    order_by 0
    sequence(:text) { |n| "Answer Text #{n}" }
  end
end
