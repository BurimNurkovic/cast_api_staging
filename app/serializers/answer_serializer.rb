# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  text        :string(255)
#  order_by    :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :text, :order_by
end
