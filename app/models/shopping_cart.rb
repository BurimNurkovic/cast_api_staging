class ShoppingCart < ActiveRecord::Base
  belongs_to :user
  serialize :products

  STATUSES = %w(new finished closed expired)
  validates :status, inclusion: { in: STATUSES }
  # new - just created
  # finished - user redirect to the amazon page
  # closed - user was redirect and clicked at the 'Continue' button
  # expired - the cart was tagged as expired

  def as_json(options = nil)
    super( { except: [:response_body, :user_id, :cart_hmac] }.merge(options || {}) )
  end

  def product_with amazon_id
    self.products.find { |p| p.asin == amazon_id } if self.products
  end

  def finish!
    self.status = 'finished'
    self.save
  end
end
