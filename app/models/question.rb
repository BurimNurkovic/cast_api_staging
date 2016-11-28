# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  text          :string(255)
#  question_type :integer
#  limit         :integer          default(1), not null
#  order_by      :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Question < ActiveRecord::Base
  has_many :answers
  has_many :responses
  accepts_nested_attributes_for :answers
  enum question_type: [ :radio, :checkbox, :select_multi, :select_ordered ]

  def display_name
    text
  end
end
