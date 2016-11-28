class ShoppingProductImage < ActiveRecord::Base
  def self.create_or_update(asin, image_full_url, image_thumb_url)
    product_image = self.find_or_create_by(asin: asin)
    product_image.image_full_url = image_full_url
    product_image.image_thumb_url = image_thumb_url
    product_image.save
  end
end
