class AddRequestParamsToProductSearchLogs < ActiveRecord::Migration
  def change
    add_column :product_search_logs, :request_params, :text
  end
end
