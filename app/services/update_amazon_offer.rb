class UpdateAmazonOffer
  include Virtus.model

  def self.call(*args)
    new(*args).call
  end

  # Parameters

  attribute :amazon_id, String
  attribute :offer_listing_id, String
  attribute :normal_price, String
  attribute :sale_price, String
  attribute :lowest_price, String

  def call
    Rails.cache.fetch("AmazonOffer/#{amazon_id}", expires_in: 30.minutes) do
      AmazonOffer.create_or_update(amazon_id, offer_listing_id, normal_price, sale_price, lowest_price)
    end
  end
end
