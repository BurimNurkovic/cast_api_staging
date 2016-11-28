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

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :question_type, :limit, :order_by
  has_many :answers
end
