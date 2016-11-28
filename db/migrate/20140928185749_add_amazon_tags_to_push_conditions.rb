class AddAmazonTagsToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :amazon_tags, :string
  end
end
