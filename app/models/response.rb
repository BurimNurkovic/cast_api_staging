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

class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validate :only_answer_belongs_question
  after_create :clear_brand_responses_cache

  delegate :text, to: :answer, prefix: true, allow_nil: true

  private
  def only_answer_belongs_question
    if self.answer.question_id != self.question_id
      errors.add(:answer, 'do not belongs to the selected question')
    end
  end

  def clear_brand_responses_cache
    Rails.cache.delete("UserFavoriteBrands/#{self.user_id}")
  end
end
