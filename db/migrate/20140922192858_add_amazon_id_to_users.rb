class AddAmazonIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :amazon_id, :string
  end
end
