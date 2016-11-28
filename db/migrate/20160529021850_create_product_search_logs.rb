class CreateProductSearchLogs < ActiveRecord::Migration
  def change
    create_table :product_search_logs do |t|
      t.integer :user_id
      t.string :status, default: 'success'
      t.string :search_type
      t.string :search_level
      t.string :keywords
      t.integer :current_page
      t.integer :products_count, default: 0
      t.text :search_results

      t.timestamps
    end
  end
end
