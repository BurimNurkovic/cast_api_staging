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

class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :amazon_id, :advert_title, :advert_vendor, :advert_image_url, :advert_price_amount, :advert_price_currency, :advert_price_formatted
end
