class UpdateShoppingProductImage
  include Virtus.model

  def self.call(*args)
    new(*args).call
  end

  # Parameters
  attribute :asin, String
  attribute :image_full_url, String
  attribute :image_thumb_url, String

  def call
    Rails.cache.fetch("ShoppingProductImage/#{asin}", expires_in: 7.days) do
      ShoppingProductImage.create_or_update(asin, image_full_url, image_thumb_url)
    end
  end
end
