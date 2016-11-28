class AddStatusToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :status, :string, default: 'pending'
  end
end
