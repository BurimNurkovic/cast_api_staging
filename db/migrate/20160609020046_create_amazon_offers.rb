class CreateAmazonOffers < ActiveRecord::Migration
  def change
    create_table :amazon_offers do |t|
      t.string :amazon_id, index: true
      t.string :offer_listing_id
      t.integer :normal_price
      t.integer :sale_price
      t.integer :lowest_price

      t.timestamps
    end
  end
end
