ActiveAdmin.register ShoppingCart do
  menu priority: 3
  permit_params :user_id, :status

  index do
    selectable_column
    id_column
    column :status
    column :user
    column :product_type_count
    column :sub_total_formatted
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs nil do
      f.input :user
      f.input :status, as: :select, collection: ShoppingCart::STATUSES
    end
    f.actions
  end

  show do |cart|
    attributes_table  do
      row :user
      row :status
      row :created_at
      row :updated_at
      row :product_type_count
      row :sub_total_formatted

      panel "Products" do
        table_for cart.products do
          column :cart_item_id
          column(:image) { |product| (link_to(image_tag(product.image_thumb_url), product.image_full_url, target: :blank)) if product }
          column(:asin) { |product| (link_to(product.asin, "http://www.amazon.com/gp/product/#{product.asin}", target: :blank)) if product }
          column :seller
          column :quantity
          column :title
          column :product_group
          column 'Subtotal', :price_formatted
          column(:total) { |product| number_to_currency(product.total_price.to_i * 0.01) }
        end
      end
    end

    attributes_table do
      row :cart_id
      row :cart_hmac
      row :sub_total_amount
      row :sub_total_currency
      row :purchase_url
      row :response_body
    end
  end
end
