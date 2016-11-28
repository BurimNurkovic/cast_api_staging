class CreatePushTexts < ActiveRecord::Migration
  def change
    create_table :push_texts do |t|
      t.string :text
      t.references :push_condition, index: true

      t.timestamps
    end
  end
end
