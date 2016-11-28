class ProductSearchPagination
  attr_accessor :user, :search_level, :keywords, :search_type, :next_page_info

  def initialize(user, search_level, search_params)
    @user = user
    @search_level = search_level
    @keywords = search_params[:keywords]
    @search_type = search_params[:search_type] #hair, skin
  end

  def next_page
    previous_page_info = Rails.cache.read(cache_key)
    puts cache_key

    if previous_page_info &&
      previous_page_info[:current_page] <= 9 &&
      previous_page_info[:total_pages] > previous_page_info[:current_page]

      next_page_num = previous_page_info[:current_page] + 1
    end
    puts "next_page_num #{next_page_num}"

    @next_page_info = {
      current_page: next_page_num || 1,
      updated_at: Time.now.to_s,
      # total_pages: previous_page_info[:total_pages]
    }

    write_next_page_info
    @next_page_info[:current_page]
  end

  def page_amount(search_results)
    @next_page_info[:total_pages] = search_results[:total_pages].to_i
    write_next_page_info
  end

  def search_token
    Digest::MD5.hexdigest(@keywords)
  end

  def write_next_page_info
    puts @next_page_info
    Rails.cache.write(cache_key, @next_page_info, expires_in: 2.days)
  end

  def cache_key
    "SearchPag/#{@user.id}/#{@search_level}/#{search_token}"
  end
end
