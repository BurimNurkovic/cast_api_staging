module AmazonEcommerce
  class AmazonProductSearch < AmazonEcommerce::AmazonQuery
    attr_accessor :keywords, :search_index, :current_page, :request_isvalid_value, :error_messages, :ignored_keywords

    def initialize(search_index: 'All')
      self.search_index = search_index
      super()
    end

    def search(keywords: ,current_page: 1, ignored_keywords: [])
      self.error_messages = []
      self.ignored_keywords = ignored_keywords
      self.keywords = keywords
      self.current_page = current_page
      query = {
        'Keywords' => self.keywords,
        'SearchIndex' => self.search_index,
        'ResponseGroup' => 'Medium, Images, Offers',
        'ItemPage' => current_page,
      }
      begin
        response = self.request.item_search({ query: query })
        self.response_body = response.body
        self.response_hash = response.to_h
        update_products
      rescue => e
        self.request_isvalid_value = "False"
        self.error_messages << { message: e.message.try(:strip) }
      end
      response_attributes
    end

    private

    def response_attributes
      if self.error_messages.blank?
        {
          current_page: self.current_page.to_s,
          total_pages: response_hash['ItemSearchResponse']['Items']['TotalPages'],
          total_results: response_hash['ItemSearchResponse']['Items']['TotalResults'],
          products: self.products
        }
      else
        {
          error: [request_isvalid_value, self.error_messages.map {|error| error[:message] }.join(', ')]
        }
      end
    end

    def update_products
      errors = response_hash['ItemSearchResponse']['Items']['Request']['Errors'].try(:[], 'Error')
      self.request_isvalid_value = response_hash['ItemSearchResponse']["Items"]["Request"]["IsValid"]

      if self.request_isvalid_value == 'True' and errors.blank?
        items = response_hash['ItemSearchResponse']["Items"]["Item"]
        process_products items.is_a?(Array) ? items : [items]
      else
        self.error_messages = parse_errors errors
      end # IsValid
    end

    def process_products(products)
      self.products = []
      products.each do |product|
        if self.ignored_keywords.select {|ignored_keyword|
          product['ItemAttributes']['Title'].downcase.include?(ignored_keyword)
          }.blank?

          offers = product['Offers']
          if offers.is_a? Array
            offer = offers.try(:first).try(:[],'Offer').try(:[],'OfferListing')
          else
            offer = offers.try(:[],'Offer').try(:[],'OfferListing')
          end

          offer_listing_id = offer.try(:[],'OfferListingId')
          sale_price = offer.try(:[],'SalePrice').try(:[],'FormattedPrice')
          normal_price = offer.try(:[],'Price').try(:[],'FormattedPrice')
          lowest_price = product['OfferSummary'].try(:[],'LowestNewPrice').try(:[],'FormattedPrice')

          editorial_review = product.try(:[],'EditorialReviews').try(:[],'EditorialReview')

          if editorial_review.is_a?(Hash)
            description = editorial_review.try(:[],'Content')
          elsif editorial_review.is_a?(Array)
            single_reviews = editorial_review.select {|review| review.try(:[],'Source') == 'Product Description' }
            description = single_reviews[0].try(:[],'Content')
          end

          if description
            description = description.gsub(%r~<br\s*\/?>~, "\n")
            description = Sanitize.fragment(description).strip
          end

          feature = product['ItemAttributes']['Feature']
          feature = [feature] if feature.is_a?(String)

          item = {
            id:               product['ASIN'],
            manufacturer:     product['ItemAttributes']['Manufacturer'],
            title:            product['ItemAttributes']['Title'],
            feature:          feature,
            description:      description,
            image_full_url:   product['LargeImage'].try(:[],'URL'),
            image_thumb_url:  product['SmallImage'].try(:[],'URL'),
            price:            sale_price || normal_price,
          }

          self.products << item unless item[:price].blank?
          update_shopping_product_image item[:id], item[:image_full_url], item[:image_thumb_url]

          update_offer item[:id], offer_listing_id, normal_price, sale_price, lowest_price
        end
      end
    end

    def update_shopping_product_image(asin, image_full_url, image_thumb_url)
      UpdateShoppingProductImage.call(asin: asin, image_full_url: image_full_url,
        image_thumb_url: image_thumb_url)
    end

    def update_offer(amazon_id, offer_listing_id, normal_price, sale_price, lowest_price)
      if !amazon_id.blank? && !offer_listing_id.blank?
        UpdateAmazonOffer.call(amazon_id: amazon_id, offer_listing_id: offer_listing_id,
          normal_price: normal_price, sale_price: sale_price, lowest_price: lowest_price)
      end
    end
  end
end
