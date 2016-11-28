class CreatePushConditions < ActiveRecord::Migration
  def change
    create_table :push_conditions do |t|
      t.string :skin_type
      t.string :hair_type
      t.integer :minimum_temperature
      t.integer :maximum_temperature
      t.integer :minimum_humidity
      t.integer :maximum_humidity
      t.string :time_of_a_day

      t.timestamps
    end
  end
end
