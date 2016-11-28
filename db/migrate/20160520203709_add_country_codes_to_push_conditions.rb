class AddCountryCodesToPushConditions < ActiveRecord::Migration
  def change
    add_column :push_conditions, :country_codes, :text
  end
end
