class AmazonProductSearchService
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model
  # Parameters
  attribute :user, User
  attribute :item_page, Integer
  attribute :keywords, String
  attribute :request_params, Hash

  # Response attributes
  attribute :response, Hash

  # Internal
  attribute :amazon_service, CastProductSearch
  attribute :search_level, String

  def call
    self.response = { products: {} }

    self.amazon_service = CastProductSearch.new
    do_search
    respond_success
  end

  private

  def do_search
    self.search_level = 'first'

    self.response[:products] = perform_search(search_type: 'products', keywords: keywords)
  end

  def perform_search(args)
    # Initialize an object to manage the pagination
    pagination = ProductSearchPagination.new(self.user, self.search_level, args)
    args[:current_page] = pagination.next_page

    search_args = {}

    search_results = self.amazon_service.search args.merge(search_args)
    # set page results
    pagination.page_amount(search_results)

    self.request_params.merge!(search_args)

    log_search args, search_results, self.amazon_service.response_body
    search_results
  end

  def log_search(args, search_results, response_body)
    log_data = args.merge(search_results: search_results, search_level: self.search_level, request_params: self.request_params, response_body: response_body)
    self.user.product_search_logs.create(log_data)
  end


  def respond_success
    self.response
  end

end
