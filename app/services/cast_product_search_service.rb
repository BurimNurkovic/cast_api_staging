class CastProductSearchService
  def self.call(*args)
    new(*args).call
  end

  include Virtus.model
  # Parameters
  attribute :user, User
  attribute :hair_item_page, Integer
  attribute :skin_item_page, Integer
  attribute :hair_keywords, Array
  attribute :skin_keywords, Array
  attribute :request_params, Hash
  attribute :unify_products, Boolean
  attribute :products_limit, Integer
  attribute :prioritize_brands, Boolean


  # Response attributes
  attribute :response, Hash

  # Internal
  attribute :amazon_service, CastProductSearch
  attribute :search_level, String

  def call
    self.response = { hair: {}, skin: {} }

    self.amazon_service = CastProductSearch.new
    trigger_cascade_search
    unify_products! if unify_products
    respond_success
  end

  private

  def trigger_cascade_search()
    first_level_search
    second_level_search
    last_level_search
  end

  def first_level_search
    self.search_level = 'first'

    self.response[:hair] = perform_search(search_type: 'hair',
      keywords: hair_keywords.join(' ') + ' hair ' + self.user.hair_type)

    self.response[:skin] = perform_search(search_type: 'skin',
      keywords: skin_keywords.join(' ') + ' skin ' + self.user.skin_type)
  end

  def second_level_search
    self.search_level = 'second'

    unless self.response[:hair].try(:[], :error).blank?
      self.response[:hair] = perform_search(search_type: 'hair',
        keywords: hair_keywords[0].to_s + ' hair ' + self.user.hair_type)
    end

    unless self.response[:skin].try(:[], :error).blank?
      self.response[:skin] = perform_search(search_type: 'skin',
        keywords: skin_keywords[0].to_s + ' skin ' + self.user.skin_type)
    end

  end

  def last_level_search
    self.search_level = 'third'

    unless self.response[:hair].try(:[], :error).blank?
      self.response[:hair] = perform_search(search_type: 'hair',
        keywords:'hair ' + self.user.hair_type)
    end

    unless self.response[:skin].try(:[], :error).blank?
      self.response[:skin] = perform_search(search_type: 'skin',
        keywords:'skin ' + self.user.skin_type)
    end
  end


  def perform_search(args)
    # Initialize an object to manage the pagination
    pagination = ProductSearchPagination.new(self.user, self.search_level, args)
    args[:current_page] = pagination.next_page

    search_args = { products_limit: products_limit }
    search_args[:prioritized_brands] = self.user.favorite_brands if prioritize_brands

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

  def unify_products!
    self.response[:products] = []
    self.response[:products] << self.response.delete(:hair)[:products]
    self.response[:products] << self.response.delete(:skin)[:products]
    self.response[:products].flatten!
  end

  def respond_success
    # { success: true, render_arguments: [json: self.response, status: :ok] }
    self.response
  end

end
