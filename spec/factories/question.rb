FactoryGirl.define do
  factory :question do
    sequence(:text) { |n| "Question Text #{n}" }
    question_type 1
    limit 1
    order_by 0

    factory :question_with_answers do
      transient do
        answers_count 3
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

  end
end
