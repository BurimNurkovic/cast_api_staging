class ShoppingCartService
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model
  # Parameters
  attribute :amazon_id, String
  attribute :user, User
  attribute :method, String
  attribute :quantity, Integer

  # Response attributes
  attribute :shopping_cart, ShoppingCart

  def call
    self.user = user
    self.shopping_cart = find_or_create_shopping_cart

    amazon_shopping_cart = trigger_shopping_cart(method, amazon_id, quantity)

    # return an Array with the errors
    if amazon_shopping_cart.is_a? Array
      render_error translate_errors(amazon_shopping_cart), amazon_shopping_cart
    else

      update_shopping_cart(amazon_shopping_cart)
      if self.shopping_cart.save
        respond_success
      else
        render_error self.shopping_cart.errors.full_messages
      end
    end

  end

  private

  def find_or_create_shopping_cart
    existing_shopping_cart = self.user.shopping_carts.where(status: 'new').first
    existing_shopping_cart || self.user.shopping_carts.new
  end

  def initialize_amazon_shopping_cart
    if self.shopping_cart.cart_id
      AmazonShoppingCart.new(self.shopping_cart.cart_id, self.shopping_cart.cart_hmac)
    else
      AmazonShoppingCart.new
    end
  end

  def update_shopping_cart(amazon_shopping_cart)
    self.shopping_cart.cart_id = amazon_shopping_cart.cart_id
    self.shopping_cart.cart_hmac = amazon_shopping_cart.cart_hmac
    self.shopping_cart.purchase_url = amazon_shopping_cart.purchase_url
    self.shopping_cart.product_type_count = amazon_shopping_cart.products.try(:size).to_i
    self.shopping_cart.sub_total_amount = amazon_shopping_cart.sub_total_amount
    self.shopping_cart.sub_total_currency = amazon_shopping_cart.sub_total_currency
    self.shopping_cart.sub_total_formatted = amazon_shopping_cart.sub_total_formatted
    self.shopping_cart.products = amazon_shopping_cart.products
    self.shopping_cart.items_count = amazon_shopping_cart.items_count
    self.shopping_cart.response_body = amazon_shopping_cart.response_body
  end

  def trigger_shopping_cart(method, amazon_id = nil, quantity = nil)
    amazon_shopping_cart = initialize_amazon_shopping_cart
    product = self.shopping_cart.product_with amazon_id unless method == 'show'

    if self.shopping_cart.new_record? and method != 'create'
      result = [{code: 'CastAPI.NotInitializedCart', message: I18n.t('aws_errors.CastAPI_NotInitializedCart')}]
    end

    case method
    when 'create', 'update'
      offer = AmazonOffer.where(amazon_id: amazon_id).order(updated_at: :desc).first

      # Increment if there is no quantity
      if quantity.blank?
        quantity = product.try(:quantity).to_i + 1
      end

      result = amazon_shopping_cart.add_or_increase(
        amazon_id,
        offer.try(:offer_listing_id),
        product.try(:cart_item_id),
        quantity
      )

    when 'destroy'
      result = amazon_shopping_cart.remove product.try :cart_item_id
    when 'show'
      result = amazon_shopping_cart.get
    end unless result

    # if no error happen return the shopping cart otherwise an array of errors
    result == true ? amazon_shopping_cart : result
  end

  def respond_success
    { success: true, render_arguments: [json: { shopping_cart: shopping_cart }, status: :ok] }
  end

  def render_error(errors, original_errors = [])
    { success: false, render_arguments: [json: { errors: errors, original_errors: original_errors }, status: :unprocessable_entity] }
  end

  def translate_errors(errors)
    errors.map do |error|
      I18n.t "aws_errors.#{error[:code].gsub('.','_')}"
    end.uniq
  end
end
