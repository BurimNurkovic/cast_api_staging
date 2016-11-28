class AmazonShoppingCart
  attr_accessor :cart_id, :purchase_url, :cart_hmac, :request, :response_body, :products,
    :sub_total_amount, :sub_total_currency, :sub_total_formatted, :items_count

  def initialize(cart_id = nil, cart_hmac = nil)
    self.cart_id = cart_id if cart_id
    self.cart_hmac = cart_hmac if cart_hmac

    self.request = Vacuum.new('US', true)
    self.request.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['AWS_ASSOCIATE_TAG']
      )
  end


  def add(amazon_id, offer_listing_id = nil, quantity = 1)
    action = self.cart_id ? :cart_add : :cart_create
    query = {
      'CartId' => self.cart_id,
      'HMAC' => (self.cart_hmac || ENV['AWS_HMAC']),
      'Item.1.Quantity' => quantity
      }

    if offer_listing_id.blank?
      query['Item.1.ASIN'] = amazon_id
    else
      query['Item.1.OfferListingId'] = offer_listing_id
    end

    response = self.request.try action, { query: query }
    update_attributes_from response
  end


  def add_or_increase(amazon_id, offer_listing_id = nil, cart_item_id = nil, quantity = 1)
    if cart_item_id
      # update existing product at cart
      modify cart_item_id, quantity
    else
      # create a new item at the cart
      add amazon_id, offer_listing_id, quantity
    end
  end

  def get(cart_item_id = nil)
    response = self.request.cart_get(
      query: {
        'CartId' => self.cart_id,
        'HMAC' => self.cart_hmac,
        'CartItemId' => cart_item_id
        })

    update_attributes_from response
  end

  def remove(cart_item_id)
    if cart_item_id
      modify cart_item_id, 0
    else
      parse_errors({'Code' => 'CastAPI.NotFoundCartItem', 'Message' => "Cart Item #{cart_item_id} not found"})
    end
  end

  def modify(cart_item_id, quantity)
    response = self.request.cart_modify(
      query: {
        'CartId' => self.cart_id,
        'HMAC' => self.cart_hmac,
        'CartItemId' => cart_item_id,
        'Item.1.CartItemId' => cart_item_id,
        'Item.1.Quantity' => quantity
        })
    update_attributes_from response
  end

  private

  def update_attributes_from response
    self.response_body = response.body
    response_hash = response.to_h
    method = response_hash.keys[0]
    errors = response_hash[method]["Cart"]["Request"]["Errors"].try(:[], 'Error')

    if response_hash[method]["Cart"]["Request"]["IsValid"] == 'True' and errors.blank?

      if method == 'CartCreateResponse'
        self.cart_id = response_hash[method]["Cart"]["CartId"]
        self.cart_hmac = response_hash[method]["Cart"]["HMAC"]
      end

      # check if there is items at the cart
      if response_hash[method]["Cart"]["CartItems"]
        if response_hash[method]["Cart"]["CartItems"]["CartItem"].is_a? Array
          process_products response_hash[method]["Cart"]["CartItems"]["CartItem"]
        else
          process_products [ response_hash[method]["Cart"]["CartItems"]["CartItem"] ]
        end
      else
        self.products = []
        self.items_count = 0
      end

      self.sub_total_amount = response_hash[method]["Cart"].try(:[],"SubTotal").try(:[],"Amount").to_i
      self.sub_total_currency = response_hash[method]["Cart"].try(:[],"SubTotal").try(:[],"CurrencyCode")
      self.sub_total_formatted = response_hash[method]["Cart"].try(:[],"SubTotal").try(:[],"FormattedPrice")

      self.purchase_url = response_hash[method]["Cart"]["PurchaseURL"]
      # return true if the cart is valid and the attributes was updated
      true
    else
      parse_errors errors
    end # IsValid
  end

  def process_products(cart_items)
    self.products = []
    self.items_count = 0
    cart_items.each do |cart_item|
      products << ShoppingProduct.new({
        cart_item_id: cart_item['CartItemId'],
        asin: cart_item['ASIN'],
        seller: cart_item['SellerNickname'],
        quantity: cart_item['Quantity'],
        title: cart_item['Title'],
        product_group: cart_item['ProductGroup'],
        price_amount: cart_item['Price']['Amount'],
        price_currency: cart_item['Price']['CurrencyCode'],
        price_formatted: cart_item['Price']['FormattedPrice']
        })

      self.items_count += cart_item['Quantity'].to_i
    end
    self.products = products
  end

  def parse_errors errors
    if errors.is_a? Array
      errors.map do |error|
        error_message error
      end
    else
      [error_message(errors)]
    end
  end

  def error_message error
    { code: error["Code"], message: error["Message"] }
  end
end
