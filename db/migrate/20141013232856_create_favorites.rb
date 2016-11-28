class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :amazon_id
      t.references :user, index: true

      t.timestamps
    end
  end
end
