class AmazonOffer < ActiveRecord::Base
  validates :amazon_id, presence: true
  validates :offer_listing_id, presence: true, length: { maximum: 255 }

  def self.create_or_update(amazon_id, offer_listing_id, normal_price, sale_price, lowest_price)
    offer = self.find_or_initialize_by(amazon_id: amazon_id)
    offer.offer_listing_id = offer_listing_id
    offer.normal_price = normal_price.to_s.gsub(/[^\d]/,'').to_i
    offer.sale_price = sale_price.to_s.gsub(/[^\d]/,'').to_i
    offer.lowest_price = lowest_price.to_s.gsub(/[^\d]/,'').to_i
    offer.save
  end
end
