class AddTypeToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :type, :string
  end
end
