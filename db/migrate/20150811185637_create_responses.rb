class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :user, index: true
      t.references :question, index: true
      t.references :answer, index: true
      t.integer :order_by, null: false, default: 0

      t.timestamps
    end
  end
end
