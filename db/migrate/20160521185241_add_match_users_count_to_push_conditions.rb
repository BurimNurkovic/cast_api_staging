class AddMatchUsersCountToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :match_users_count, :integer, default: 0
  end
end
