class AddInstallationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :installation_id, :string
  end
end
