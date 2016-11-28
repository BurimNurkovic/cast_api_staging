class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :age, :string
    add_column :users, :hair_type, :string
    add_column :users, :skin_type, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :auth_token, :string
  end
end
