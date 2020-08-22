class CreateSchoolposts < ActiveRecord::Migration[5.2]
  def change
    create_table :schoolposts do |t|
      t.string :title
      t.string :content
      t.date :publishdate
      t.string :link
      t.integer :catalog_id
      t.timestamps
    end
  end
end
