class AddMenuItemToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :menu_item, :string, default: 'home'
  end
end
