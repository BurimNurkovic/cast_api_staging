class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.string :cart_id
      t.string :cart_hmac
      t.references :user
      t.string :status, default: 'new'
      t.integer :product_type_count
      t.integer :items_count
      t.text :products
      t.integer :sub_total_amount
      t.string :sub_total_currency
      t.string :sub_total_formatted
      t.string :purchase_url
      t.text :response_body

      t.timestamps
    end
  end
end
