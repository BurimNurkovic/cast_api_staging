class AddUrlToBlogentries < ActiveRecord::Migration
  def change
    add_column :blogentries, :url, :string
  end
end
