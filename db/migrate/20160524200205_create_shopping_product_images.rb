class CreateShoppingProductImages < ActiveRecord::Migration
  def change
    create_table :shopping_product_images do |t|
      t.string :asin, index: true
      t.string :image_full_url
      t.string :image_thumb_url

      t.timestamps
    end
  end
end
