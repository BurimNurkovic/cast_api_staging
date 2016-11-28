# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  amazon_id  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :user

  before_create :update_advert_info

  PUBLIC_ATTRIBUTES = %w(id amazon_id advert_title advert_vendor advert_image_url advert_price_formatted)

  validates :amazon_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  def update_advert_info
    self.assign_attributes AmazonItem.search self.amazon_id
  end

  def advert_title=(title)
    write_attribute(:advert_title, title.try(:[], 0...255))
  end

  def public_attributes
    self.attributes.select {|k,v| PUBLIC_ATTRIBUTES.include?(k) }
  end
end
