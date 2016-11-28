class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true
      t.string :text
      t.integer :order_by, null: false, default: 0

      t.timestamps
    end
  end
end
