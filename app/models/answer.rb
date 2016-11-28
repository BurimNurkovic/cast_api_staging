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

class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :responses

  default_scope -> { order(:order_by) }

  def display_name
    text
  end
end
