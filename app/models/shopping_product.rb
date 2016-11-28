class ShoppingProduct
  extend ActiveModel::Callbacks
  include ActiveModel::Model

  define_model_callbacks :initialize, only: [:after, :before]
  after_initialize :update_image_urls

  attr_accessor :cart_item_id, :asin, :seller, :quantity, :title, :product_group, :price_amount, :price_currency, :price_formatted, :image_full_url, :image_thumb_url

  def initialize(attributes = {})
    run_callbacks :initialize do
      super(attributes)
    end
  end

  def total_price
    self.price_amount.to_i * self.quantity.to_i
  end

  def shopping_product_image
    ShoppingProductImage.where(asin: self.asin).first
  end

  def update_image_urls
    shopping_product_image = self.shopping_product_image
    if shopping_product_image
      self.image_full_url = shopping_product_image.image_full_url
      self.image_thumb_url = shopping_product_image.image_thumb_url
    end
  end

end
