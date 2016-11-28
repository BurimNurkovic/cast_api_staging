class ProductSearchLog < ActiveRecord::Base
  belongs_to :user
  serialize :search_results
  store :request_params, accessors: [ :link ]
  before_create :update_status

  def scratchpad_url
    "http://webservices.amazon.com/scratchpad/index.html#http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemSearch&SubscriptionId=#{ENV['AWS_ACCESS_KEY_ID']}&AssociateTag=#{ENV['AWS_ASSOCIATE_TAG']}&SearchIndex=Beauty&Keywords=#{self.keywords}&ResponseGroup=Images,ItemAttributes,Offers&ItemPage=#{self.current_page}"
  end

  private
  def update_status
    if self.search_results.keys.include?(:error)
      self.status = 'error'
    else
      self.status = 'cached' if self.search_results.try(:[], :hits_cache) == true
      self.products_count = self.search_results.try(:[], :products).try(:size).to_i
    end
  end
end
