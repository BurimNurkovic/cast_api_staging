module AmazonItem
  def self.search(amazon_id)
    request = Vacuum.new('US', true)
    request.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['AWS_ASSOCIATE_TAG']
      )

    response = request.item_lookup(
      query: {
        'ItemId' => amazon_id,
        'ResponseGroup' => 'Small, Images, OfferSummary'
        })
    response_hash = response.to_h
    favorite_params = {}

    if response_hash["ItemLookupResponse"]["Items"]["Request"]["Errors"].blank?
      item_data = response_hash["ItemLookupResponse"]["Items"]["Item"]
      favorite_params[:advert_title] = item_data["ItemAttributes"]["Title"]
      favorite_params[:advert_vendor] = item_data["ItemAttributes"]["Manufacturer"]
      favorite_params[:advert_image_url] = item_data["LargeImage"]["URL"]
      lowest_new_price = item_data["OfferSummary"]["LowestNewPrice"]

      if lowest_new_price
        favorite_params[:advert_price_amount] = lowest_new_price["Amount"]
        favorite_params[:advert_price_currency] = lowest_new_price["CurrencyCode"]
        favorite_params[:advert_price_formatted] = lowest_new_price["FormattedPrice"]
      end
    end

    favorite_params
  end
end
