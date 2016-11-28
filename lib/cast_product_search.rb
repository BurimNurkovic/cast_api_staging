class CastProductSearch < AmazonEcommerce::AmazonProductSearch
  HAIR_IGNORED_KEYWORDS = %w(weave wig accessory accessories extension remy brazilian virgin human bundle braid clip\ in hairpiece)

  def initialize
    super(search_index: 'Beauty')
  end

  def search(keywords: ,current_page: 1, search_type: 'skin', products_limit: 10, prioritized_brands: [])
    search_attributes = {
      keywords: keywords,
      current_page: current_page,
    }
    search_attributes[:ignored_keywords] = HAIR_IGNORED_KEYWORDS if search_type == 'hair'
    search_cache_key = "ProductSearchCache/#{search_type}/#{keywords.parameterize.underscore}/#{current_page}"

    if Rails.cache.exist?(search_cache_key) && !Rails.env.test?
      search_results = Rails.cache.read(search_cache_key).merge(hits_cache: true)
    else
      search_results = super(search_attributes)
      Rails.cache.write(search_cache_key, search_results.merge(hits_cache: false), expires_in: 1.day)
    end

    if search_results.keys.include?(:error)
      Rails.cache.delete(search_cache_key)
      search_results
    else
      parse_search_results(search_results, products_limit, prioritized_brands)
    end
  end

  # Do not cache this process right now to don't affect the normal search
  def parse_search_results(search_results, products_limit, prioritized_brands)
    if !prioritized_brands.blank?
      search_results[:products].each_with_index do |product,index|
        if prioritized_brands.include?(product[:manufacturer])
          search_results[:products].insert(0, search_results[:products].delete_at(index))
        end
      end
    end

    if products_limit.between?(1,9)
      search_results[:products] = search_results[:products][0, products_limit]
    end

    search_results
  end
end
