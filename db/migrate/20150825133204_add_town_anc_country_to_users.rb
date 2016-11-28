class AddTownAncCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :postal_town, :string
    add_column :users, :country, :string
  end
end
