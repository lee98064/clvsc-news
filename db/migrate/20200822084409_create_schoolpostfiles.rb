class CreateSchoolpostfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :schoolpostfiles do |t|
      t.string :name
      t.string :link
      t.integer :schoolpost_id

      t.timestamps
    end
  end
end
