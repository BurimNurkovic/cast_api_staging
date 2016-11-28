# == Schema Information
#
# Table name: responses
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  answer_id   :integer
#  order_by    :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ResponseSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :answer_id, :order_by
end
