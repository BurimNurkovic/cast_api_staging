class CreateApiV1Locations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :user, index: true
      t.string :display_name
      t.string :link

      t.timestamps
    end
  end
end
