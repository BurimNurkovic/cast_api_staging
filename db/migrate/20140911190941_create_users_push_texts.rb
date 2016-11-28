class CreateUsersPushTexts < ActiveRecord::Migration
  def change
    create_table :push_texts_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :push_text
    end
  end
end
