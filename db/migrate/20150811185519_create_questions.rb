class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :question_type
      t.integer :limit, null: false, default: 1
      t.integer :order_by, null: false, default: 0

      t.timestamps
    end
  end
end
