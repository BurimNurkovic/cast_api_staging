class AddAdvertFieldsToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :advert_title, :string
    add_column :favorites, :advert_vendor, :string
    add_column :favorites, :advert_image_url, :string
    add_column :favorites, :advert_price_amount, :integer
    add_column :favorites, :advert_price_currency, :string
    add_column :favorites, :advert_price_formatted, :string
  end
end
