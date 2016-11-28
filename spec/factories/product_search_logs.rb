FactoryGirl.define do
  factory :product_search_log do
    user_id 1
    search_type "MyString"
    keywords "MyString"
    current_page 1
    products_count 1
    search_results "MyText"
  end
end
