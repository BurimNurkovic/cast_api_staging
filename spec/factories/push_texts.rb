# == Schema Information
#
# Table name: push_texts
#
#  id                :integer          not null, primary key
#  text              :string(255)
#  push_condition_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :push_text do
    text "MyString"
    push_condition nil
  end
end
