class AddUpdateToCatalog < ActiveRecord::Migration[5.2]
  def change
    add_column :catalogs, :update_everyday, :boolean
  end
end
