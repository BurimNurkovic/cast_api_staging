class AddResponseBodyToProductSearchLog < ActiveRecord::Migration
  def change
    add_column :product_search_logs, :response_body, :text
  end
end
