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

class PushText < ActiveRecord::Base
  belongs_to :push_condition

  has_and_belongs_to_many :users

  scope :sent_to_user, lambda { |user_id| joins(:users).where('push_texts_users.user_id = ?', user_id).pluck(:id) }

  def delete_user(user)
    users.delete(user)
  end
end
