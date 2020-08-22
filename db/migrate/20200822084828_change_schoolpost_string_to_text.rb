class ChangeSchoolpostStringToText < ActiveRecord::Migration[5.2]
  def change
    change_column :schoolposts, :content, :text
  end
end
