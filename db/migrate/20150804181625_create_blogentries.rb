class CreateBlogentries < ActiveRecord::Migration
  def change
    create_table :blogentries do |t|
      t.integer :blog_type
      t.string :title
      t.text :text
      t.string :video_url
      t.boolean :is_deleted, null: false, default: false
      t.integer :status

      t.timestamps
    end
    add_attachment :blogentries, :image
  end
end
