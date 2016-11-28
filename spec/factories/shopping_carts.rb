FactoryGirl.define do
  factory :shopping_cart do
    cart_id "MyString"
    user ""
    status "MyString"
    product_type_count 1
    items_count 1
    products "MyText"
    sub_total_amount 1
    sub_total_currency "MyString"
    sub_total_formatted "MyString"
    purchase_url "MyString"
    request_body "MyText"
  end
end
